import 'package:isar/isar.dart';
import 'package:isar_test/isar_test.dart';
import 'package:test/test.dart';

part 'filter_byte_test.g.dart';

@collection
class ByteModel {
  ByteModel(this.id, this.field);

  final int id;

  byte field;

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    return other is ByteModel && other.id == id && other.field == field;
  }
}

void main() {
  group('Byte filter', () {
    late Isar isar;
    late IsarCollection<int, ByteModel> col;

    late ByteModel objMin;
    late ByteModel obj1;
    late ByteModel obj2;
    late ByteModel obj3;
    late ByteModel objMax;

    setUp(() {
      isar = openTempIsar([ByteModelSchema]);
      col = isar.byteModels;

      objMin = ByteModel(0, 0);
      obj1 = ByteModel(1, 1);
      obj2 = ByteModel(2, 123);
      obj3 = ByteModel(3, 1);
      objMax = ByteModel(4, 255);

      isar.writeTxn((isar) {
        col.putAll([objMin, obj1, obj2, obj3, objMax]);
      });
    });

    isarTest('.equalTo()', () {
      expect(col.where().fieldEqualTo(0).findAll(), [objMin]);
      expect(col.where().fieldEqualTo(1).findAll(), [obj1, obj3]);
    });

    isarTest('.lessThan()', () {
      expect(
        col.where().fieldLessThan(255).findAll(),
        [objMin, obj1, obj2, obj3],
      );
      expect(
        col.where().fieldLessThan(255, include: true).findAll(),
        [objMin, obj1, obj2, obj3, objMax],
      );
      expect(col.where().fieldLessThan(0).findAll(), isEmpty);
      expect(col.where().fieldLessThan(0, include: true).findAll(), [objMin]);
    });

    isarTest('.between()', () {
      expect(
        col.where().fieldBetween(0, 255).findAll(),
        [objMin, obj1, obj2, obj3, objMax],
      );
      expect(
        col.where().fieldBetween(0, 255, includeLower: false).findAll(),
        [obj1, obj2, obj3, objMax],
      );
      expect(
        col.where().fieldBetween(0, 255, includeUpper: false).findAll(),
        [objMin, obj1, obj2, obj3],
      );
      expect(col.where().fieldBetween(255, 0).findAll(), isEmpty);
      expect(col.where().fieldBetween(100, 110).findAll(), isEmpty);
    });
  });
}
