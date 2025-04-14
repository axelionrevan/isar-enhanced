// ignore_for_file: empty_catches

import "package:encrypt/encrypt.dart";
import "package:isar/package/dart_utils/dart_utils.dart";

///
abstract class DartDatabaseBase {
  ///
  final String pathToFile;

  ///
  DartDatabaseBase({
    required this.pathToFile,
  });

  static final String _encryptKey = "95S753U2J82cAO95r3e27ItJNOqS7u8h";
  static final IV _encryptIv = IV.fromBase64("tYHr/b0PyyrYb61dTuI9TQ==");

  static final Encrypter _encrypter = Encrypter(
    AES(
      Key.fromUtf8(DartDatabaseBase._encryptKey),
      mode: AESMode.ctr,
    ),
  );

  ///
  String encrypt({
    required String data,
  }) {
    return DartDatabaseBase._encrypter.encrypt(data, iv: DartDatabaseBase._encryptIv).base64;
  }

  ///
  String decrypt({
    required String data,
  }) {
    return DartDatabaseBase._encrypter.decrypt64(data, iv: DartDatabaseBase._encryptIv);
  }

  ///
  ///
  ///
  String readSyncRaw();

  ///
  void writeSyncRaw({
    required String content,
  });

  ///
  ///
  ///
  String readSync() {
    try {
      // wasm release not support
      // encrypt List data so
      if (DartUtils.isWasm) {
        return readSyncRaw();
      }
      return decrypt(data: readSyncRaw());
    } catch (e) {}
    return "";
  }

  ///
  void writeSync({
    required String content,
  }) {
    try {
      // wasm release not support
      // encrypt List data so
      if (DartUtils.isWasm) {
        writeSyncRaw(
          content: content,
        );
        return;
      }
      writeSyncRaw(
        content: encrypt(
          data: content,
        ),
      );
      return;
    } catch (e) {}
    return;
  }
}
