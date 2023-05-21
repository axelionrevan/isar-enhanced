import 'dart:io';
import 'dart:math';

import 'package:isar/isar.dart';
import 'package:isar_test/isar_test.dart';
import 'package:test/test.dart';

part 'compact_on_launch_test.g.dart';

@Collection()
class Model {
  int id = Random().nextInt(999999);

  List<int> buffer = List.filled(16000, 42);

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Model &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          listEquals(buffer, other.buffer);

  @override
  String toString() {
    return 'Model{id: $id}';
  }
}

void main() {
  group('Compact on launch', () {
    late Isar isar;
    late File file;

    setUp(() {
      isar = openTempIsar([ModelSchema]);
      file = File('${isar.directory}/${isar.name}.isar');

      isar.writeTxn((isar) => isar.models.putAll(List.filled(100, Model())));
    });

    isarTest('No compact on launch', () {
      isar.close();
      final size1 = file.lengthSync();

      isar = openTempIsar([ModelSchema], name: isar.name);
      isar.writeTxn((isar) => isar.models.where().deleteAll(limit: 50));
      isar.close();

      final size2 = file.lengthSync();

      isar = openTempIsar([ModelSchema], name: isar.name);

      expect(size1, size2);
    });

    isarTest('minFileSize', () {
      isar.close();
      final size1 = file.lengthSync();

      isar = openTempIsar([ModelSchema], name: isar.name);
      isar.writeTxn((isar) => isar.models.where().deleteAll(limit: 50));
      isar.close();

      isar = openTempIsar(
        [ModelSchema],
        name: isar.name,
        compactOnLaunch: CompactCondition(minFileSize: size1 * 2),
      );
      isar.close();
      final size2 = file.lengthSync();
      expect(size1, size2);

      isar = openTempIsar(
        [ModelSchema],
        name: isar.name,
        compactOnLaunch: CompactCondition(minFileSize: size1 ~/ 2),
      );
      final size3 = file.lengthSync();
      expect(size3, lessThan(size2));
    });

    isarTest('minBytes', () {
      isar.close();
      final size1 = file.lengthSync();

      isar = openTempIsar([ModelSchema], name: isar.name);
      isar.writeTxn((isar) => isar.models.where().deleteAll(limit: 10));
      isar.close();

      isar = openTempIsar(
        [ModelSchema],
        name: isar.name,
        compactOnLaunch: CompactCondition(minBytes: size1 ~/ 2),
      );
      isar.close();
      final size2 = file.lengthSync();
      expect(size1, size2);

      isar = openTempIsar(
        [ModelSchema],
        name: isar.name,
        compactOnLaunch: CompactCondition(minBytes: size1 ~/ 2),
      );
      isar.writeTxn((isar) => isar.models.where().deleteAll(limit: 90));
      isar.close();
      final size3 = file.lengthSync();
      expect(size3, size2);

      isar = openTempIsar(
        [ModelSchema],
        name: isar.name,
        compactOnLaunch: CompactCondition(minBytes: size1 ~/ 2),
      );
      final size4 = file.lengthSync();
      expect(size4, lessThan(size3));
    });

    isarTest('minRatio', () {
      isar.close();
      final size1 = file.lengthSync();

      isar = openTempIsar([ModelSchema], name: isar.name);
      isar.writeTxn((isar) => isar.models.where().deleteAll(limit: 10));
      isar.close();

      isar = openTempIsar(
        [ModelSchema],
        name: isar.name,
        compactOnLaunch: const CompactCondition(minRatio: 2),
      );
      isar.close();
      final size2 = file.lengthSync();
      expect(size1, size2);

      isar = openTempIsar(
        [ModelSchema],
        name: isar.name,
        compactOnLaunch: const CompactCondition(minRatio: 2),
      );
      isar.writeTxn((isar) => isar.models.where().deleteAll(limit: 80));
      isar.close();
      final size3 = file.lengthSync();
      expect(size3, size2);

      isar = openTempIsar(
        [ModelSchema],
        name: isar.name,
        compactOnLaunch: const CompactCondition(minRatio: 2),
      );
      final size4 = file.lengthSync();
      expect(size4, lessThan(size3));
    });
  });
}
