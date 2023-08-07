use super::{FALSE_BOOL, NULL_DOUBLE, NULL_FLOAT, NULL_INT, NULL_LONG, TRUE_BOOL};
use crate::core::data_type::DataType;
use byteorder::{ByteOrder, LittleEndian};
use std::str::from_utf8_unchecked;
use xxhash_rust::xxh3::xxh3_64_with_seed;

#[derive(Copy, Clone, Eq, PartialEq)]
pub(crate) struct IsarDeserializer<'a> {
    pub bytes: &'a [u8],
    static_size: u32,
}

impl<'a> IsarDeserializer<'a> {
    #[inline]
    pub fn from_bytes(bytes: &'a [u8]) -> Self {
        let static_size = LittleEndian::read_u24(bytes);
        Self {
            bytes: &bytes[3..], // account for static size
            static_size,
        }
    }

    #[inline]
    fn contains_offset(&self, offset: u32) -> bool {
        self.static_size > offset
    }

    #[inline]
    pub fn is_null(&self, offset: u32, data_type: DataType) -> bool {
        match data_type {
            DataType::Bool => self.read_bool(offset).is_none(),
            DataType::Byte => !self.contains_offset(offset),
            DataType::Int => self.read_int(offset) == NULL_INT,
            DataType::Float => self.read_float(offset).is_nan(),
            DataType::Long => self.read_long(offset) == NULL_LONG,
            DataType::Double => self.read_double(offset).is_nan(),
            _ => self.get_offset_length(offset).is_none(),
        }
    }

    #[inline]
    pub fn read_bool(&self, offset: u32) -> Option<bool> {
        if self.contains_offset(offset) {
            match self.bytes[offset as usize] {
                FALSE_BOOL => Some(false),
                TRUE_BOOL => Some(true),
                _ => None,
            }
        } else {
            None
        }
    }

    #[inline]
    pub fn read_byte(&self, offset: u32) -> u8 {
        if self.contains_offset(offset) {
            self.bytes[offset as usize]
        } else {
            0
        }
    }

    #[inline]
    pub fn read_int(&self, offset: u32) -> i32 {
        if self.contains_offset(offset) {
            LittleEndian::read_i32(&self.bytes[offset as usize..])
        } else {
            NULL_INT
        }
    }

    #[inline]
    pub fn read_float(&self, offset: u32) -> f32 {
        if self.contains_offset(offset) {
            LittleEndian::read_f32(&self.bytes[offset as usize..])
        } else {
            NULL_FLOAT
        }
    }

    #[inline]
    pub fn read_long(&self, offset: u32) -> i64 {
        if self.contains_offset(offset) {
            LittleEndian::read_i64(&self.bytes[offset as usize..])
        } else {
            NULL_LONG
        }
    }

    #[inline]
    pub fn read_double(&self, offset: u32) -> f64 {
        if self.contains_offset(offset) {
            LittleEndian::read_f64(&self.bytes[offset as usize..])
        } else {
            NULL_DOUBLE
        }
    }

    #[inline]
    fn get_offset(&self, offset: u32) -> Option<usize> {
        if self.contains_offset(offset) {
            let offset = LittleEndian::read_u24(&self.bytes[offset as usize..]);
            if offset > 0 {
                return Some(offset as usize);
            }
        }
        None
    }

    #[inline]
    fn get_offset_length(&self, offset: u32) -> Option<(usize, usize)> {
        let offset = self.get_offset(offset)?;
        let length = LittleEndian::read_u24(&self.bytes[offset as usize..]);
        Some((offset as usize + 3, length as usize))
    }

    #[inline]
    pub fn read_dynamic(&self, offset: u32) -> Option<&'a [u8]> {
        let (offset, length) = self.get_offset_length(offset)?;
        let bytes = &self.bytes[offset..offset + length];
        Some(bytes)
    }

    #[inline]
    pub fn read_string(&self, offset: u32) -> Option<&'a str> {
        let bytes = self.read_dynamic(offset)?;
        unsafe { Some(from_utf8_unchecked(bytes)) }
    }

    #[inline]
    pub fn read_nested(&self, offset: u32) -> Option<IsarDeserializer<'a>> {
        let offset = self.get_offset(offset)?;
        let object = Self::from_bytes(&self.bytes[offset..]);
        Some(object)
    }

    #[inline]
    pub fn read_list(
        &self,
        offset: u32,
        element_type: DataType,
    ) -> Option<(IsarDeserializer<'a>, u32)> {
        let nested = self.read_nested(offset)?;
        let length = nested.static_size / element_type.static_size() as u32;
        Some((nested, length))
    }

    pub fn hash_property(
        &self,
        offset: u32,
        data_type: DataType,
        case_sensitive: bool,
        mut seed: u64,
    ) -> u64 {
        match data_type {
            DataType::Byte => xxh3_64_with_seed(&[self.read_byte(offset)], seed),
            DataType::Int => xxh3_64_with_seed(&self.read_int(offset).to_le_bytes(), seed),
            DataType::Float => {
                let value = self.read_float(offset);
                if value.is_nan() {
                    xxh3_64_with_seed(&[1, 0, 128, 127], seed)
                } else {
                    xxh3_64_with_seed(&value.to_le_bytes(), seed)
                }
            }
            DataType::Long => xxh3_64_with_seed(&self.read_long(offset).to_le_bytes(), seed),
            DataType::Double => {
                let value = self.read_float(offset);
                if value.is_nan() {
                    xxh3_64_with_seed(&[0, 0, 0, 0, 0, 0, 248, 127], seed)
                } else {
                    xxh3_64_with_seed(&value.to_le_bytes(), seed)
                }
            }
            DataType::String => {
                if let Some(str) = self.read_string(offset) {
                    seed = xxh3_64_with_seed(&[1], seed);
                    if case_sensitive {
                        xxh3_64_with_seed(str.as_bytes(), seed)
                    } else {
                        xxh3_64_with_seed(str.to_lowercase().as_bytes(), seed)
                    }
                } else {
                    xxh3_64_with_seed(&[0], seed)
                }
            }
            _ => seed,
        }
    }
}
