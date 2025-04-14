import 'base/base.dart';

///
class DartDatabase extends DartDatabaseBase {
  ///
  DartDatabase({required super.pathToFile});

  @override
  String readSyncRaw() {
    return "";
  }

  @override
  void writeSyncRaw({required String content}) {
    return;
  }
}
