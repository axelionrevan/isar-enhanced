use super::error::Result;
use super::{data_type::DataType, error::IsarError};
use itertools::Itertools;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Clone, Hash)]
pub struct IsarSchema {
    pub collections: Vec<CollectionSchema>,
}

impl IsarSchema {
    pub fn new(collections: Vec<CollectionSchema>) -> Self {
        IsarSchema { collections }
    }

    pub fn from_json(json: &[u8]) -> Result<Self> {
        if let Ok(collections) = serde_json::from_slice::<Vec<CollectionSchema>>(json) {
            Ok(Self::new(collections))
        } else {
            schema_error("Could not deserialize schema JSON")
        }
    }

    pub fn verify_schema(&self) -> Result<()> {
        for col in &self.collections {
            col.verify(&self.collections)?;
        }
        Ok(())
    }
}

#[derive(Serialize, Deserialize, Clone, Hash)]
pub struct CollectionSchema {
    pub name: String,
    #[serde(default)]
    pub embedded: bool,
    pub properties: Vec<PropertySchema>,
    #[serde(default)]
    pub indexes: Vec<IndexSchema>,
    #[serde(default)]
    pub(crate) version: u8,
}

impl CollectionSchema {
    pub fn new(
        name: &str,
        properties: Vec<PropertySchema>,
        indexes: Vec<IndexSchema>,
        embedded: bool,
    ) -> CollectionSchema {
        CollectionSchema {
            name: name.to_lowercase(),
            embedded,
            properties,
            indexes,
            version: 0,
        }
    }

    pub fn find_changes(
        &self,
        old_collection: &CollectionSchema,
    ) -> (
        Vec<&'_ PropertySchema>,
        Vec<String>,
        Vec<&'_ IndexSchema>,
        Vec<(String, bool)>,
    ) {
        let mut add_properties = Vec::new();
        let mut drop_properties = Vec::new();
        let mut add_indexes = Vec::new();
        let mut drop_indexes = Vec::new();

        for old_prop in &old_collection.properties {
            let prop = self.properties.iter().find(|p| p.name == old_prop.name);
            if let Some(prop) = prop {
                if prop.data_type != old_prop.data_type || prop.collection != old_prop.collection {
                    add_properties.push(prop);
                    drop_properties.push(prop.name.as_ref().unwrap().clone());
                }
            } else if let Some(old_prop_name) = &old_prop.name {
                drop_properties.push(old_prop_name.clone());
            }
        }

        for prop in &self.properties {
            if let Some(prop_name) = &prop.name {
                let does_not_exist = !old_collection
                    .properties
                    .iter()
                    .any(|p| p.name.as_deref() == Some(prop_name));
                if does_not_exist {
                    add_properties.push(prop);
                }
            }
        }

        for old_index in &old_collection.indexes {
            let index = self.indexes.iter().find(|i| i.name == old_index.name);
            if let Some(index) = index {
                let property_dropped = index.properties.iter().any(|p| drop_properties.contains(p));
                if index.unique != old_index.unique
                    || &index.properties != &old_index.properties
                    || property_dropped
                {
                    add_indexes.push(index);
                    drop_indexes.push((old_index.name.clone(), old_index.unique));
                }
            } else {
                drop_indexes.push((old_index.name.clone(), old_index.unique));
            }
        }

        for index in &self.indexes {
            let does_not_exist = !old_collection
                .indexes
                .iter()
                .any(|old_index| index.name == old_index.name);
            if does_not_exist {
                add_indexes.push(index);
            }
        }

        (add_properties, drop_properties, add_indexes, drop_indexes)
    }

    fn verify(&self, collections: &[CollectionSchema]) -> Result<()> {
        verify_name(&self.name)?;

        if self.embedded && !self.indexes.is_empty() {
            return schema_error("Embedded objects must not have indexes.");
        }

        let verify_target_col_exists = |col: &str, embedded: bool| -> Result<()> {
            if !collections
                .iter()
                .any(|c| c.name == col && c.embedded == embedded)
            {
                return schema_error("Target collection does not exist.");
            }
            Ok(())
        };

        for property in &self.properties {
            if let Some(name) = &property.name {
                verify_name(name)?;
            }

            if property.data_type == DataType::Object || property.data_type == DataType::ObjectList
            {
                if let Some(target_col) = &property.collection {
                    verify_target_col_exists(target_col, true)?;
                } else {
                    return schema_error("Object property must have a target collection.");
                }
            } else {
                if property.collection.is_some() {
                    return schema_error(
                        "Target collection can only be set for object properties.",
                    );
                }
            }
        }

        let property_names = self
            .properties
            .iter()
            .unique_by(|p| p.name.as_ref().unwrap());
        if property_names.count() != self.properties.len() {
            return schema_error("Duplicate property name")?;
        }

        let index_names = self.indexes.iter().unique_by(|i| i.name.as_str());
        if index_names.count() != self.indexes.len() {
            return schema_error("Duplicate index name");
        }

        for index in &self.indexes {
            if index.properties.is_empty() {
                return schema_error("At least one property needs to be added to a valid index");
            } else if index.properties.len() > 3 {
                return schema_error(
                    "No more than three properties may be used as a composite index",
                );
            }

            for (i, index_property) in index.properties.iter().enumerate() {
                let property = self
                    .properties
                    .iter()
                    .find(|p| p.name.as_ref() == Some(&index_property));
                if property.is_none() {
                    return schema_error("IsarIndex property does not exist");
                }
                let property = property.unwrap();

                if property.data_type == DataType::Object
                    || property.data_type == DataType::ObjectList
                {
                    return schema_error("Object and ObjectList cannot be indexed.");
                }

                if property.data_type == DataType::Float
                    || property.data_type == DataType::Double
                    || property.data_type == DataType::FloatList
                    || property.data_type == DataType::DoubleList
                {
                    if i != index.properties.len() - 1 {
                        return schema_error(
                            "Float indexes must only be at the end of a composite index.",
                        );
                    }
                }

                if property.data_type.is_list() {
                    if index.properties.len() > 1 {
                        return schema_error("Composite list indexes are not supported.");
                    }
                }
            }
        }

        Ok(())
    }
}

fn schema_error<T>(msg: &str) -> Result<T> {
    Err(IsarError::SchemaError {
        message: msg.to_string(),
    })
}

fn verify_name(name: &str) -> Result<()> {
    if name.is_empty() {
        schema_error("Empty names are not allowed.")
    } else if name.starts_with('_') {
        schema_error("Names must not begin with an underscore.")
    } else if name.starts_with("sqlite_") {
        schema_error("Names must not begin with 'sqlite_'.")
    } else {
        Ok(())
    }
}

#[derive(Serialize, Deserialize, Clone, Eq, PartialEq, Hash, Debug)]
pub struct PropertySchema {
    pub name: Option<String>,
    #[serde(rename = "type")]
    pub data_type: DataType,
    #[serde(default)]
    #[serde(rename = "target")]
    pub collection: Option<String>,
}

impl PropertySchema {
    pub fn new(name: &str, data_type: DataType, collection: Option<&str>) -> PropertySchema {
        PropertySchema {
            name: Some(name.to_lowercase()),
            data_type,
            collection: collection.map(|col| col.to_lowercase()),
        }
    }
}

#[derive(Serialize, Deserialize, Clone, Eq, PartialEq, Hash)]
pub struct IndexSchema {
    pub name: String,
    pub properties: Vec<String>,
    #[serde(rename = "caseSensitive")]
    pub case_sensitive: bool,
    pub unique: bool,
    pub hash: bool,
}

impl IndexSchema {
    pub fn new(
        name: &str,
        properties: Vec<&str>,
        case_sensitive: bool,
        unique: bool,
        hash: bool,
    ) -> IndexSchema {
        IndexSchema {
            name: name.to_lowercase(),
            properties: properties.iter().map(|p| p.to_lowercase()).collect(),
            case_sensitive,
            unique,
            hash,
        }
    }
}
