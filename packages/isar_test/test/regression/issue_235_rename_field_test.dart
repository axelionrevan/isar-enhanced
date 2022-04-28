import 'package:test/test.dart';
import 'package:isar/isar.dart';

import '../util/common.dart';
import '../util/sync_async_helper.dart';

part 'issue_235_rename_field_test.g.dart';

@Collection()
@Name('Collection')
class Col1 {
  int? id;

  int number;

  String numberText3;
  String numberText2;
  String numberText1;

  Col1({
    required this.id,
    this.number = 22,
    this.numberText3 = "Default Value3",
    this.numberText2 = "Default Value2",
    this.numberText1 = "Default Value1",
  });
}

@Collection()
@Name('Collection')
class Col2 {
  int id;

  int? number;

  String? numberText3;
  String? numberText22;
  String? numberText1;

  Col2({
    required this.id,
    this.number,
    this.numberText3,
    this.numberText22,
    this.numberText1,
  });

  @override
  operator ==(other) {
    return other is Col2 &&
        other.id == id &&
        other.number == number &&
        other.numberText3 == numberText3 &&
        other.numberText22 == numberText22 &&
        other.numberText1 == numberText1;
  }
}

void main() {
  testSyncAsync(tests);
}

void tests() {
  isarTest('Regression 235 Rename field', () async {
    final isar1 = await openTempIsar([Col1Schema]);
    await isar1.tWriteTxn((isar) {
      return isar.col1s.tPut(Col1(id: 5));
    });
    expect(await isar1.close(), true);

    final isar2 = await openTempIsar([Col2Schema], name: isar1.name);
    final existing = await isar2.col2s.tGet(5);
    expect(
      existing,
      Col2(
        id: 5,
        number: 22,
        numberText3: "Default Value3",
        numberText1: "Default Value1",
      ),
    );

    final newObj = Col2(
      id: 5,
      number: 111,
      numberText3: "New Value3",
      numberText1: "New Value1",
      numberText22: 'New Value22',
    );
    await isar2.tWriteTxn((isar) {
      return isar.col2s.tPut(newObj);
    });
    expect(await isar2.col2s.tGet(5), newObj);
    expect(await isar2.close(), true);
  });
}
