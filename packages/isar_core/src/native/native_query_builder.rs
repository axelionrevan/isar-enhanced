use super::native_collection::NativeCollection;
use super::native_filter::NativeFilter;
use super::query::{Query, QueryIndex};
use crate::core::data_type::DataType;
use crate::core::query_builder::{IsarQueryBuilder, Sort};
use crate::core::value::IsarValue;
use crate::filter::filter_condition::{ConditionType, FilterCondition};
use crate::filter::filter_group::{FilterGroup, GroupType};
use crate::filter::Filter;
use itertools::Itertools;
use std::hint::black_box;

pub struct NativeQueryBuilder<'a> {
    instance_id: u32,
    collection: &'a NativeCollection,
    all_collections: &'a [NativeCollection],
    filter: Option<Filter>,
    sort: Vec<(u16, Sort, bool)>,
    distinct: Vec<(u16, bool)>,
}

impl<'a> NativeQueryBuilder<'a> {
    pub fn new(
        instance_id: u32,
        collection: &'a NativeCollection,
        all_collections: &'a [NativeCollection],
    ) -> Self {
        Self {
            instance_id,
            collection,
            all_collections,
            filter: None,
            sort: Vec::new(),
            distinct: Vec::new(),
        }
    }
}

impl<'a> IsarQueryBuilder for NativeQueryBuilder<'a> {
    type Query = Query;

    fn set_filter(&mut self, filter: Filter) {
        self.filter = Some(filter);
    }

    fn add_sort(&mut self, property_index: u16, sort: Sort, case_sensitive: bool) {
        self.sort.push((property_index, sort, case_sensitive));
    }

    fn add_distinct(&mut self, property_index: u16, case_sensitive: bool) {
        self.distinct.push((property_index, case_sensitive));
    }

    fn build(self) -> Self::Query {
        let filter = self
            .filter
            .map(|f| f.to_native_filter(self.collection, self.all_collections))
            .unwrap_or(NativeFilter::stat(true));
        Query::new(
            self.instance_id,
            self.collection.collection_index,
            black_box(vec![QueryIndex::Full(Sort::Asc)]),
            filter,
            vec![],
            vec![],
        )
    }
}

impl Filter {
    fn to_native_filter(
        &self,
        collection: &NativeCollection,
        all_collections: &[NativeCollection],
    ) -> NativeFilter {
        match self {
            Filter::Condition(condition) => condition.to_native_filter(collection),
            Filter::Group(group) => group.to_native_filter(collection, all_collections),
            Filter::Nested(_) => todo!(),
        }
    }
}

impl FilterGroup {
    fn to_native_filter(
        &self,
        collection: &NativeCollection,
        all_collections: &[NativeCollection],
    ) -> NativeFilter {
        match self.get_group_type() {
            GroupType::And => {
                let filters = self
                    .get_filters()
                    .iter()
                    .map(|f| f.to_native_filter(collection, all_collections))
                    .collect_vec();
                NativeFilter::and(filters)
            }
            GroupType::Or => {
                let filters = self
                    .get_filters()
                    .iter()
                    .map(|f| f.to_native_filter(collection, all_collections))
                    .collect_vec();
                NativeFilter::or(filters)
            }
            GroupType::Not => {
                let filter = self.get_filters()[0].to_native_filter(collection, all_collections);
                NativeFilter::not(filter)
            }
        }
    }
}

impl FilterCondition {
    fn to_native_filter(&self, collection: &NativeCollection) -> NativeFilter {
        let property = collection.get_property(self.get_property_index());
        match self.get_condition_type() {
            ConditionType::IsNull => {
                if let Some(property) = property {
                    NativeFilter::is_null(property)
                } else {
                    NativeFilter::stat(false)
                }
            }
            ConditionType::Between => {
                if let Some(property) = property {
                    match property.data_type {
                        DataType::Bool | DataType::BoolList => {
                            if let (IsarValue::Bool(lower), IsarValue::Bool(upper)) =
                                self.get_lower_upper()
                            {
                                return NativeFilter::bool(property, *lower, *upper);
                            }
                        }
                        DataType::Byte | DataType::ByteList => {
                            if let (IsarValue::Integer(lower), IsarValue::Integer(upper)) =
                                self.get_lower_upper()
                            {
                                let lower = if *lower == i64::MIN {
                                    u8::MIN as i64
                                } else if *lower == i64::MIN + 1 {
                                    u8::MIN as i64 + 1
                                } else {
                                    *lower
                                };
                                let upper = if *upper == i64::MIN {
                                    u8::MIN as i64
                                } else if *upper == i64::MIN + 1 {
                                    u8::MIN as i64 + 1
                                } else {
                                    *upper
                                };
                                if lower <= u8::MAX as i64 && upper >= u8::MIN as i64 {
                                    return NativeFilter::byte(
                                        property,
                                        lower.clamp(u8::MIN as i64, u8::MAX as i64) as u8,
                                        upper.clamp(u8::MIN as i64, u8::MAX as i64) as u8,
                                    );
                                }
                            }
                        }
                        DataType::Int | DataType::IntList => {
                            if let (IsarValue::Integer(lower), IsarValue::Integer(upper)) =
                                self.get_lower_upper()
                            {
                                let lower = if *lower == i64::MIN {
                                    i32::MIN as i64
                                } else if *lower == i64::MIN + 1 {
                                    i32::MIN as i64 + 1
                                } else {
                                    *lower
                                };
                                let upper = if *upper == i64::MIN {
                                    i32::MIN as i64
                                } else if *upper == i64::MIN + 1 {
                                    i32::MIN as i64 + 1
                                } else {
                                    *upper
                                };
                                if lower <= i32::MAX as i64 && upper >= i32::MIN as i64 {
                                    return NativeFilter::int(
                                        property,
                                        lower.clamp(i32::MIN as i64, i32::MAX as i64) as i32,
                                        upper.clamp(i32::MIN as i64, i32::MAX as i64) as i32,
                                    );
                                }
                            }
                        }
                        DataType::Float | DataType::FloatList => {
                            if let (IsarValue::Real(lower), IsarValue::Real(upper)) =
                                self.get_lower_upper()
                            {
                                return NativeFilter::float(property, *lower as f32, *upper as f32);
                            }
                        }
                        DataType::Long | DataType::LongList => {
                            if let (IsarValue::Integer(lower), IsarValue::Integer(upper)) =
                                self.get_lower_upper()
                            {
                                return NativeFilter::long(property, *lower, *upper);
                            }
                        }
                        DataType::Double | DataType::DoubleList => {
                            if let (IsarValue::Real(lower), IsarValue::Real(upper)) =
                                self.get_lower_upper()
                            {
                                return NativeFilter::double(property, *lower, *upper);
                            }
                        }
                        DataType::String | DataType::StringList => {
                            if let (IsarValue::String(lower), IsarValue::String(upper)) =
                                self.get_lower_upper()
                            {
                                return NativeFilter::string(
                                    property,
                                    lower.as_deref(),
                                    upper.as_deref(),
                                    self.get_case_sensitive(),
                                );
                            }
                        }
                        _ => {}
                    }
                } else {
                    if let (IsarValue::Integer(lower), IsarValue::Integer(upper)) =
                        self.get_lower_upper()
                    {
                        return NativeFilter::id(*lower, *upper);
                    }
                }
                NativeFilter::stat(false)
            }
            ConditionType::StringEndsWith => {
                if let Some(property) = property {
                    if let IsarValue::String(Some(value)) = self.get_value() {
                        match property.data_type {
                            DataType::String | DataType::StringList => {
                                return NativeFilter::string_ends_with(
                                    property,
                                    value,
                                    self.get_case_sensitive(),
                                )
                            }
                            _ => {}
                        }
                    }
                }
                NativeFilter::stat(false)
            }
            ConditionType::StringContains => {
                if let Some(property) = property {
                    if let IsarValue::String(Some(value)) = self.get_value() {
                        match property.data_type {
                            DataType::String | DataType::StringList => {
                                return NativeFilter::string_contains(
                                    property,
                                    value,
                                    self.get_case_sensitive(),
                                )
                            }
                            _ => {}
                        }
                    }
                }
                NativeFilter::stat(false)
            }
            ConditionType::StringMatches => {
                if let Some(property) = property {
                    if let IsarValue::String(Some(value)) = self.get_value() {
                        match property.data_type {
                            DataType::String | DataType::StringList => {
                                return NativeFilter::string_matches(
                                    property,
                                    value,
                                    self.get_case_sensitive(),
                                )
                            }
                            _ => {}
                        }
                    }
                }
                NativeFilter::stat(false)
            }
            ConditionType::True => NativeFilter::stat(true),
            ConditionType::False => NativeFilter::stat(false),
        }
    }
}
