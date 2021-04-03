part of isar_native;

class BinaryReader {
  static const utf8Decoder = Utf8Decoder();

  final Uint8List _buffer;
  final ByteData _byteData;
  late int _staticSize;

  BinaryReader(this._buffer)
      : _byteData = ByteData.view(_buffer.buffer, _buffer.offsetInBytes) {
    _staticSize = _byteData.getUint16(0, Endian.little);
  }

  @pragma('vm:prefer-inline')
  bool readBool(int offset, {bool staticOffset = true}) {
    if (staticOffset && offset >= _staticSize) return false;
    final value = _buffer[offset];
    if (value == trueBool) {
      return true;
    } else {
      return false;
    }
  }

  @pragma('vm:prefer-inline')
  bool? readBoolOrNull(int offset, {bool staticOffset = true}) {
    if (staticOffset && offset >= _staticSize) return null;
    final value = _buffer[offset];
    if (value == trueBool) {
      return true;
    } else if (value == falseBool) {
      return false;
    }
  }

  @pragma('vm:prefer-inline')
  int readInt(int offset, {bool staticOffset = true}) {
    if (staticOffset && offset >= _staticSize) return nullInt;
    return _byteData.getInt32(offset, Endian.little);
  }

  @pragma('vm:prefer-inline')
  int? readIntOrNull(int offset, {bool staticOffset = true}) {
    final value = readInt(offset, staticOffset: staticOffset);
    if (value != nullInt) {
      return value;
    }
  }

  @pragma('vm:prefer-inline')
  double readFloat(int offset, {bool staticOffset = true}) {
    if (staticOffset && offset >= _staticSize) return nullFloat;
    return _byteData.getFloat32(offset, Endian.little);
  }

  @pragma('vm:prefer-inline')
  double? readFloatOrNull(int offset, {bool staticOffset = true}) {
    final value = readFloat(offset, staticOffset: staticOffset);
    if (!value.isNaN) {
      return value;
    }
  }

  @pragma('vm:prefer-inline')
  int readLong(int offset, {bool staticOffset = true}) {
    if (staticOffset && offset >= _staticSize) return nullLong;
    return _byteData.getInt64(offset, Endian.little);
  }

  @pragma('vm:prefer-inline')
  int? readLongOrNull(int offset, {bool staticOffset = true}) {
    final value = readLong(offset, staticOffset: staticOffset);
    if (value != nullLong) {
      return value;
    }
  }

  @pragma('vm:prefer-inline')
  double readDouble(int offset, {bool staticOffset = true}) {
    if (staticOffset && offset >= _staticSize) return nullDouble;
    return _byteData.getFloat64(offset, Endian.little);
  }

  @pragma('vm:prefer-inline')
  double? readDoubleOrNull(int offset, {bool staticOffset = true}) {
    final value = readDouble(offset, staticOffset: staticOffset);
    if (!value.isNaN) {
      return value;
    }
  }

  @pragma('vm:prefer-inline')
  DateTime readDateTime(int offset, {bool staticOffset = true}) {
    final time = readLong(offset, staticOffset: staticOffset);
    return DateTime.fromMicrosecondsSinceEpoch(time, isUtc: true).toLocal();
  }

  @pragma('vm:prefer-inline')
  DateTime? readDateTimeOrNull(int offset, {bool staticOffset = true}) {
    final time = readLongOrNull(offset, staticOffset: staticOffset);
    if (time != null) {
      return DateTime.fromMicrosecondsSinceEpoch(time, isUtc: true).toLocal();
    }
  }

  @pragma('vm:prefer-inline')
  String readString(int offset, {bool staticOffset = true}) {
    return readStringOrNull(offset, staticOffset: staticOffset) ?? '';
  }

  @pragma('vm:prefer-inline')
  String? readStringOrNull(int offset, {bool staticOffset = true}) {
    if (staticOffset && offset >= _staticSize) return null;
    final bytesOffset = _buffer.readUint32(offset);
    if (bytesOffset == 0) {
      return null;
    }
    final length = _buffer.readUint32(offset + 4);

    return utf8Decoder.convert(_buffer, bytesOffset, bytesOffset + length);
  }

  Uint8List readBytes(int offset, {bool staticOffset = true}) {
    return readBytesOrNull(offset, staticOffset: staticOffset) ??
        Uint8List.fromList([]);
  }

  Uint8List? readBytesOrNull(int offset, {bool staticOffset = true}) {
    if (staticOffset && offset >= _staticSize) return null;
    final bytesOffset = _buffer.readUint32(offset);
    if (bytesOffset == 0) {
      return null;
    }
    final length = _buffer.readUint32(offset + 4);
    return _buffer.view(bytesOffset, length);
  }

  List<bool>? readBoolList(int offset) {
    if (offset >= _staticSize) return [];

    final listOffset = _buffer.readUint32(offset);
    final length = _buffer.readUint32(offset + 4);
    if (listOffset == 0) return null;

    final list = <bool>[];
    for (var i = 0; i < length; i++) {
      list.add(readBool(listOffset + i, staticOffset: false));
    }
    return list;
  }

  List<bool?>? readBoolOrNullList(int offset) {
    if (offset >= _staticSize) return [];

    final listOffset = _buffer.readUint32(offset);
    final length = _buffer.readUint32(offset + 4);
    if (listOffset == 0) return null;

    final list = <bool?>[];
    for (var i = 0; i < length; i++) {
      list.add(readBool(listOffset + i, staticOffset: false));
    }
    return list;
  }

  List<int>? readIntList(int offset) {
    if (offset >= _staticSize) return [];

    final listOffset = _buffer.readUint32(offset);
    final length = _buffer.readUint32(offset + 4);
    if (listOffset == 0) return null;

    final list = <int>[];
    for (var i = 0; i < length; i++) {
      list.add(_byteData.getInt32(listOffset + i * 4, Endian.little));
    }
    return list;
  }

  List<int?>? readIntOrNullList(int offset) {
    if (offset >= _staticSize) return [];

    final listOffset = _buffer.readUint32(offset);
    final length = _buffer.readUint32(offset + 4);
    if (listOffset == 0) return null;

    final list = <int?>[];
    for (var i = 0; i < length; i++) {
      list.add(readIntOrNull(listOffset + i * 4, staticOffset: false));
    }
    return list;
  }

  List<double>? readFloatList(int offset) {
    if (offset >= _staticSize) return [];

    final listOffset = _buffer.readUint32(offset);
    final length = _buffer.readUint32(offset + 4);
    if (listOffset == 0) return null;

    final list = <double>[];
    for (var i = 0; i < length; i++) {
      list.add(_byteData.getFloat32(listOffset + i * 4, Endian.little));
    }
    return list;
  }

  List<double?>? readFloatOrNullList(int offset) {
    if (offset >= _staticSize) return [];

    final listOffset = _buffer.readUint32(offset);
    final length = _buffer.readUint32(offset + 4);
    if (listOffset == 0) return null;

    final list = <double?>[];
    for (var i = 0; i < length; i++) {
      list.add(readFloatOrNull(listOffset + i * 4, staticOffset: false));
    }
    return list;
  }

  List<int>? readLongList(int offset) {
    if (offset >= _staticSize) return [];

    final listOffset = _buffer.readUint32(offset);
    final length = _buffer.readUint32(offset + 4);
    if (listOffset == 0) return null;

    final list = <int>[];
    for (var i = 0; i < length; i++) {
      list.add(_byteData.getInt64(listOffset + i * 8, Endian.little));
    }
    return list;
  }

  List<int?>? readLongOrNullList(int offset) {
    if (offset >= _staticSize) return [];

    final listOffset = _buffer.readUint32(offset);
    final length = _buffer.readUint32(offset + 4);
    if (listOffset == 0) return null;

    final list = <int?>[];
    for (var i = 0; i < length; i++) {
      list.add(readLongOrNull(listOffset + i * 8, staticOffset: false));
    }
    return list;
  }

  List<double>? readDoubleList(int offset) {
    if (offset >= _staticSize) return [];

    final listOffset = _buffer.readUint32(offset);
    final length = _buffer.readUint32(offset + 4);
    if (listOffset == 0) return null;

    final list = <double>[];
    for (var i = 0; i < length; i++) {
      list.add(_byteData.getFloat64(listOffset + i * 8, Endian.little));
    }
    return list;
  }

  List<double?>? readDoubleOrNullList(int offset) {
    if (offset >= _staticSize) return [];

    final listOffset = _buffer.readUint32(offset);
    final length = _buffer.readUint32(offset + 4);
    if (listOffset == 0) return null;

    final list = <double?>[];
    for (var i = 0; i < length; i++) {
      list.add(readDoubleOrNull(listOffset + i * 8, staticOffset: false));
    }
    return list;
  }

  List<DateTime>? readDateTimeList(int offset) {
    return readLongOrNullList(offset)?.map((e) {
      if (e != null) {
        return DateTime.fromMicrosecondsSinceEpoch(e, isUtc: true).toLocal();
      } else {
        return nullDate;
      }
    }).toList();
  }

  List<DateTime?>? readDateTimeOrNullList(int offset) {
    return readLongOrNullList(offset)?.map((e) {
      if (e != null) {
        return DateTime.fromMicrosecondsSinceEpoch(e, isUtc: true).toLocal();
      }
    }).toList();
  }

  List<String>? readStringList(int offset) {
    if (offset >= _staticSize) return [];

    var listOffset = _buffer.readUint32(offset);
    var length = _buffer.readUint32(offset + 4);
    if (listOffset == 0) return null;

    final list = <String>[];
    for (var i = 0; i < length; i++) {
      list.add(readString(listOffset + i * 8, staticOffset: false));
    }
    return list;
  }

  List<String?>? readStringOrNullList(int offset) {
    if (offset >= _staticSize) return [];

    var listOffset = _buffer.readUint32(offset);
    var length = _buffer.readUint32(offset + 4);
    if (listOffset == 0) return null;

    final list = <String?>[];
    for (var i = 0; i < length; i++) {
      list.add(readStringOrNull(listOffset + i * 8, staticOffset: false));
    }
    return list;
  }
}
