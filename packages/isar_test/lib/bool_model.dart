import 'package:isar/isar.dart';

@Collection()
class BoolModel {
  @Id()
  int? id;

  @Index()
  bool? field = false;

  BoolModel();

  @override
  String toString() {
    return '{field: $field}';
  }

  @override
  bool operator ==(other) {
    return (other as BoolModel).field == field;
  }
}
