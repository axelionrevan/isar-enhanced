use self::aggregate::{aggregate_min_max, aggregate_sum_average};
use self::query_iterator::QueryIterator;
use super::index::index_key::IndexKey;
use super::native_collection::{NativeCollection, NativeProperty};
use super::native_filter::NativeFilter;
use super::native_reader::NativeReader;
use super::native_txn::NativeTxn;
use crate::core::cursor::IsarCursor;
use crate::core::error::Result;
use crate::core::instance::Aggregation;
use crate::core::query_builder::Sort;
use crate::core::value::IsarValue;

mod aggregate;
mod collection_iterator;
mod index_iterator;
mod query_iterator;
mod sorted_query_iterator;
mod unsorted_distinct_query_iterator;
mod unsorted_query_iterator;

pub(crate) enum QueryIndex {
    Full(Sort),
    IdsBetween(i64, i64),
    IndexBetween(IndexKey, IndexKey),
}

pub struct Query {
    pub(crate) instance_id: u32,
    pub(crate) collection_index: u16,
    pub(self) indexes: Vec<QueryIndex>,
    pub(self) filter: NativeFilter,
    pub(self) sort: Vec<(NativeProperty, Sort)>,
    pub(self) distinct: Vec<(NativeProperty, bool)>,
}

impl Query {
    pub(crate) fn new(
        instance_id: u32,
        collection_index: u16,
        indexes: Vec<QueryIndex>,
        filter: NativeFilter,
        sort: Vec<(NativeProperty, Sort)>,
        distinct: Vec<(NativeProperty, bool)>,
    ) -> Self {
        Self {
            instance_id,
            collection_index,
            indexes,
            filter,
            sort,
            distinct,
        }
    }

    pub(crate) fn cursor<'a>(
        &'a self,
        txn: &'a NativeTxn,
        all_collections: &'a [NativeCollection],
        offset: Option<u32>,
        limit: Option<u32>,
    ) -> Result<QueryCursor<'a>> {
        let collection = &all_collections[self.collection_index as usize];
        let iterator = QueryIterator::new(
            txn,
            collection,
            self,
            false,
            offset.unwrap_or(0),
            limit.unwrap_or(u32::MAX),
        )?;
        Ok(QueryCursor::new(iterator, collection, all_collections))
    }

    pub(crate) fn aggregate<'a>(
        &'a self,
        txn: &'a NativeTxn,
        all_collections: &'a [NativeCollection],
        aggregation: Aggregation,
        property_index: Option<u16>,
    ) -> Result<Option<IsarValue>> {
        let collection = &all_collections[self.collection_index as usize];
        let property = if let Some(property_index) = property_index {
            collection.get_property(property_index as u32)
        } else {
            None
        };

        let mut iterator = QueryIterator::new(txn, collection, self, true, 0, u32::MAX)?;
        let result = match aggregation {
            Aggregation::Min | Aggregation::Max => {
                aggregate_min_max(iterator, property, aggregation == Aggregation::Min)
            }
            Aggregation::Sum | Aggregation::Average => {
                aggregate_sum_average(iterator, property, aggregation == Aggregation::Sum)
            }
            Aggregation::Count => Some(IsarValue::Integer(iterator.count() as i64)),
            Aggregation::IsEmpty => Some(IsarValue::Bool(Some(iterator.next().is_none()))),
        };
        Ok(result)
    }

    pub(crate) fn delete(&self, txn: &NativeTxn, collection: &NativeCollection) -> Result<u32> {
        todo!()
    }
}

pub struct QueryCursor<'a> {
    iterator: QueryIterator<'a>,
    collection: &'a NativeCollection,
    all_collections: &'a [NativeCollection],
}

impl<'a> QueryCursor<'a> {
    pub(crate) fn new(
        iterator: QueryIterator<'a>,
        collection: &'a NativeCollection,
        all_collections: &'a [NativeCollection],
    ) -> Self {
        Self {
            iterator,
            collection,
            all_collections,
        }
    }
}

impl<'a> IsarCursor for QueryCursor<'a> {
    type Reader<'b> = NativeReader<'b> where Self: 'b;

    #[inline]
    fn next(&mut self) -> Option<Self::Reader<'_>> {
        let (id, object) = self.iterator.next()?;
        Some(NativeReader::new(
            id,
            object,
            self.collection,
            self.all_collections,
        ))
    }
}
