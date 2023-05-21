import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:isar/isar.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

const kIsWeb = identical(0, 0.0);

final testErrors = <String>[];
int testCount = 0;

var _setUp = false;
void prepareTest() {
  if (!_setUp) {
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      final rootDir = path.dirname(path.dirname(Directory.current.path));
      final binaryName = Platform.isWindows
          ? 'isar.dll'
          : Platform.isMacOS
              ? 'libisar.dylib'
              : 'libisar.so';
      /*try {
        Isar.initializeIsarCore();
      } catch (e) {*/
      Isar.initializeIsarCore(
        libraries: {
          Abi.macosArm64: path.join(
            rootDir,
            'target',
            /*
              'aarch64-apple-darwin',
              'release',*/
            'debug',
            binaryName,
          ),
          Abi.macosX64: path.join(
            rootDir,
            'target',
            'x86_64-apple-darwin',
            'release',
            binaryName,
          ),
          Abi.linuxArm64: path.join(
            rootDir,
            'target',
            'aarch64-unknown-linux-gnu',
            'release',
            binaryName,
          ),
          Abi.linuxX64: path.join(
            rootDir,
            'target',
            'x86_64-unknown-linux-gnu',
            'release',
            binaryName,
          ),
          Abi.windowsX64: path.join(
            rootDir,
            'target',
            'x86_64-pc-windows-msvc',
            'release',
            binaryName,
          ),
        },
      );
      //}
    }
    _setUp = true;
  }
}

String getRandomName() {
  final random = Random().nextInt(pow(2, 32) as int).toString();
  return '${random}_tmp';
}

String? testTempPath;
Isar openTempIsar(
  List<CollectionSchema> schemas, {
  String? name,
  String? directory,
  int maxSizeMiB = Isar.defaultMaxSizeMiB,
  CompactCondition? compactOnLaunch,
  bool closeAutomatically = true,
}) {
  prepareTest();
  if (directory == null && testTempPath == null) {
    final dartToolDir = path.join(Directory.current.path, '.dart_tool');
    testTempPath = path.join(dartToolDir, 'test', 'tmp');
    Directory(testTempPath!).createSync(recursive: true);
  }

  final isar = Isar.open(
    schemas: schemas,
    name: name ?? getRandomName(),
    maxSizeMiB: maxSizeMiB,
    directory: directory ?? testTempPath!,
    compactOnLaunch: compactOnLaunch,
  );

  if (closeAutomatically) {
    addTearDown(() async {
      if (isar.isOpen) {
        isar.close(deleteFromDisk: true);
      }
    });
  }

  return isar;
}

@isTest
void isarTest(
  String name,
  dynamic Function() body, {
  Timeout? timeout,
  bool skip = false,
}) {
  testCount++;
  test(
    name,
    () async {
      try {
        await body();
      } catch (e, s) {
        testErrors.add('$name: $e\n$s');
        rethrow;
      }
    },
    timeout: timeout,
    skip: skip,
  );
}
