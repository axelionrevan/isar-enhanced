import 'package:isar/isar.dart';

@Collection()
class UniqueIndexModel {
  @Id()
  int? id;

  @Index(indexType: IndexType.hash, unique: true)
  String? str = '';

  @Index(unique: true)
  int? number = 0;

  @override
  String toString() {
    return '{id: $id, str: $str, number: $number}';
  }

  UniqueIndexModel();

  @override
  bool operator ==(other) {
    if (other is UniqueIndexModel) {
      return str == other.str && number == other.number;
    }
    return false;
  }
}
