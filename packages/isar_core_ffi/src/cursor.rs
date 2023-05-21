use crate::{CIsarCursor, CIsarReader};
use isar_core::core::cursor::IsarCursor;
use std::ptr;

#[no_mangle]
pub unsafe extern "C" fn isar_cursor_next(
    cursor: &'static mut CIsarCursor,
    old_reader: *mut CIsarReader,
) -> *const CIsarReader<'static> {
    if !old_reader.is_null() {
        drop(Box::from_raw(old_reader));
    }

    let reader = match cursor {
        CIsarCursor::Native(cursor) => cursor.next(),
    };
    if let Some(reader) = reader {
        Box::into_raw(Box::new(CIsarReader::Native(reader)))
    } else {
        ptr::null()
    }
}
