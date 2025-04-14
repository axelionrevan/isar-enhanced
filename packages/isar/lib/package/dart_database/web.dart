import 'base/base.dart';
import "package:web/web.dart" as web;

///
class DartDatabase extends DartDatabaseBase {
  ///
  DartDatabase({
    required super.pathToFile,
  });
  static final web.Storage _storage = web.window.localStorage;

  @override
  String readSyncRaw() {
    {
      final result = _storage.getItem(pathToFile);
      if (result is String) {
        if (result.isEmpty) {
          return "{}";
        }
        return result;
      }
    }
    return "";
  }

  @override
  void writeSyncRaw({required String content}) {
    _storage.setItem(pathToFile, content);
    return;
  }
}
