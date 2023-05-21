use crate::CIsarReader;
use isar_core::core::reader::IsarReader;
use std::{mem, ptr};

#[no_mangle]
pub unsafe extern "C" fn isar_read_id(reader: &'static CIsarReader) -> i64 {
    match reader {
        CIsarReader::Native(reader) => reader.read_id(),
        CIsarReader::NativeList(reader) => reader.read_id(),
    }
}

#[no_mangle]
pub unsafe extern "C" fn isar_read_null(reader: &'static CIsarReader, index: u32) -> bool {
    match reader {
        CIsarReader::Native(reader) => reader.is_null(index),
        CIsarReader::NativeList(reader) => reader.is_null(index),
    }
}

#[no_mangle]
pub unsafe extern "C" fn isar_read_bool(reader: &'static CIsarReader, index: u32) -> bool {
    let value = match reader {
        CIsarReader::Native(reader) => reader.read_bool(index),
        CIsarReader::NativeList(reader) => reader.read_bool(index),
    };
    value.unwrap_or(false)
}

#[no_mangle]
pub unsafe extern "C" fn isar_read_byte(reader: &'static CIsarReader, index: u32) -> u8 {
    match reader {
        CIsarReader::Native(reader) => reader.read_byte(index),
        CIsarReader::NativeList(reader) => reader.read_byte(index),
    }
}

#[no_mangle]
pub unsafe extern "C" fn isar_read_int(reader: &'static CIsarReader, index: u32) -> i32 {
    match reader {
        CIsarReader::Native(reader) => reader.read_int(index),
        CIsarReader::NativeList(reader) => reader.read_int(index),
    }
}

#[no_mangle]
pub unsafe extern "C" fn isar_read_float(reader: &'static CIsarReader, index: u32) -> f32 {
    match reader {
        CIsarReader::Native(reader) => reader.read_float(index),
        CIsarReader::NativeList(reader) => reader.read_float(index),
    }
}

#[no_mangle]
pub unsafe extern "C" fn isar_read_long(reader: &'static CIsarReader, index: u32) -> i64 {
    match reader {
        CIsarReader::Native(reader) => reader.read_long(index),
        CIsarReader::NativeList(reader) => reader.read_long(index),
    }
}

#[no_mangle]
pub unsafe extern "C" fn isar_read_double(reader: &'static CIsarReader, index: u32) -> f64 {
    match reader {
        CIsarReader::Native(reader) => reader.read_double(index),
        CIsarReader::NativeList(reader) => reader.read_double(index),
    }
}

#[no_mangle]
pub unsafe extern "C" fn isar_read_string(
    reader: &'static CIsarReader,
    index: u32,
    value: *mut *const u8,
) -> u32 {
    let str = match reader {
        CIsarReader::Native(reader) => reader.read_string(index),
        CIsarReader::NativeList(reader) => reader.read_string(index),
    };
    if let Some(str) = str {
        let len = str.len();
        let ptr = str.as_ptr();
        mem::forget(str);
        *value = ptr;
        len as u32
    } else {
        *value = ptr::null();
        0
    }
}

/*#[no_mangle]
pub unsafe extern "C" fn isar_read_blob(
    reader: &'static CIsarReader,
    index: u32,
) -> Option<Cow<'_, [u8]>>;

#[no_mangle]
pub unsafe extern "C" fn isar_read_json(
    reader: &'static CIsarReader,
    index: u32,
) -> Option<Cow<'_, Value>>;*/

#[no_mangle]
pub unsafe extern "C" fn isar_read_object(
    reader: &'static CIsarReader,
    index: u32,
) -> *mut CIsarReader<'static> {
    match reader {
        CIsarReader::Native(reader) => match reader.read_object(index) {
            Some(reader) => Box::into_raw(Box::new(CIsarReader::Native(reader))),
            None => ptr::null_mut(),
        },
        CIsarReader::NativeList(reader) => match reader.read_object(index) {
            Some(reader) => Box::into_raw(Box::new(CIsarReader::Native(reader))),
            None => ptr::null_mut(),
        },
    }
}

#[no_mangle]
pub unsafe extern "C" fn isar_read_list(
    reader: &'static CIsarReader,
    index: u32,
    list_reader: *mut *mut CIsarReader<'static>,
) -> u32 {
    match reader {
        CIsarReader::Native(reader) => match reader.read_list(index) {
            Some((reader, len)) => {
                *list_reader = Box::into_raw(Box::new(CIsarReader::NativeList(reader)));
                len
            }
            None => {
                *list_reader = ptr::null_mut();
                0
            }
        },
        CIsarReader::NativeList(reader) => match reader.read_list(index) {
            Some((reader, len)) => {
                *list_reader = Box::into_raw(Box::new(CIsarReader::NativeList(reader)));
                len
            }
            None => {
                *list_reader = ptr::null_mut();
                0
            }
        },
    }
}
