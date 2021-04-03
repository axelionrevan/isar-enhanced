part of isar;

abstract class IsarCollection<OBJ> {
  Isar get isar;

  Future<OBJ?> get(int id) => getAll([id]).then((objects) => objects[0]);

  OBJ? getSync(int id) => getAllSync([id])[0];

  Future<List<OBJ?>> getAll(List<int> ids);

  List<OBJ?> getAllSync(List<int> ids);

  Future<void> put(OBJ object) => putAll([object]);

  void putSync(OBJ object) => putAllSync([object]);

  Future<void> putAll(List<OBJ> objects);

  void putAllSync(List<OBJ> objects);

  Future<bool> delete(int id) => deleteAll([id]).then((count) => count == 1);

  bool deleteSync(int id) => deleteAllSync([id]) == 1;

  Future<int> deleteAll(List<int> ids);

  int deleteAllSync(List<int> ids);

  Future<void> importJsonRaw(Uint8List jsonBytes);

  Future<void> importJson(List<Map<String, dynamic>> json) {
    final bytes = Utf8Encoder().convert(jsonEncode(json));
    return importJsonRaw(bytes);
  }

  Future<R> exportJsonRaw<R>(R Function(Uint8List) callback,
      {bool primitiveNull = true, bool includeLinks = false});

  Future<List<Map<String, dynamic>>> exportJson(
      {bool primitiveNull = true, bool includeLinks = false}) {
    return exportJsonRaw(
      (bytes) {
        final json = jsonDecode(Utf8Decoder().convert(bytes)) as List;
        return json.cast<Map<String, dynamic>>();
      },
      primitiveNull: primitiveNull,
      includeLinks: includeLinks,
    );
  }

  QueryBuilder<OBJ, QWhere> where({bool? distinct, bool? ascending}) {
    return QueryBuilder(this, distinct, ascending);
  }

  Stream<void> watchLazy();

  Stream<OBJ?> watchObject(int id, {bool initialReturn = false});

  Stream<void> watchObjectLazy(int id);
}
