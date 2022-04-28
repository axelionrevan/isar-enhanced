import 'package:isar/isar.dart';
import 'package:test/test.dart';

import 'util/common.dart';
import 'user_model.dart';
import 'util/sync_async_helper.dart';

void main() {
  testSyncAsync(tests);
}

void tests() {
  group('Groups', () {
    late Isar isar;
    late IsarCollection<UserModel> users;

    setUp(() async {
      isar = await openTempIsar([UserModelSchema]);
      users = isar.userModels;

      await isar.writeTxn((isar) async {
        await users.putAll([
          UserModel.fill('David', 20, false),
          UserModel.fill('Emma', 30, true),
          UserModel.fill('Tina', 40, false),
          UserModel.fill('Simon', 30, false),
          UserModel.fill('Bjorn', 40, true),
        ]);
      });
    });

    tearDown(() async {
      await isar.close();
    });

    isarTest('Simple or', () async {
      await qEqualSet(
        users.where().filter().ageEqualTo(20).or().ageEqualTo(30).tFindAll(),
        [
          UserModel.fill('David', 20, false),
          UserModel.fill('Emma', 30, true),
          UserModel.fill('Simon', 30, false),
        ],
      );

      await qEqualSet(
        users.where().filter().ageEqualTo(20).ageEqualTo(30).tFindAll(),
        [
          UserModel.fill('David', 20, false),
          UserModel.fill('Emma', 30, true),
          UserModel.fill('Simon', 30, false),
        ],
      );
    });

    isarTest('Simple and', () async {
      await qEqualSet(
        users
            .where()
            .filter()
            .ageEqualTo(40)
            .and()
            .adminEqualTo(true)
            .tFindAll(),
        [UserModel.fill('Bjorn', 40, true)],
      );
    });

    isarTest('Or followed by and', () async {
      await qEqualSet(
        users
            .where()
            .filter()
            .ageEqualTo(20)
            .or()
            .ageEqualTo(30)
            .and()
            .nameEqualTo('Emma')
            .tFindAll(),
        [
          UserModel.fill('David', 20, false),
          UserModel.fill('Emma', 30, true),
        ],
      );
    });

    isarTest('And followed by or', () async {
      await qEqualSet(
        users
            .where()
            .filter()
            .ageEqualTo(30)
            .and()
            .nameEqualTo('Simon')
            .or()
            .ageEqualTo(20)
            .tFindAll(),
        [
          UserModel.fill('David', 20, false),
          UserModel.fill('Simon', 30, false),
        ],
      );
    });

    isarTest('Or followed by group', () async {
      await qEqualSet(
        users
            .where()
            .filter()
            .ageEqualTo(20)
            .or()
            .group((q) => q.ageEqualTo(30).and().nameEqualTo('Emma'))
            .tFindAll(),
        [
          UserModel.fill('David', 20, false),
          UserModel.fill('Emma', 30, true),
        ],
      );
    });

    isarTest('And followed by group', () async {
      await qEqualSet(
        users
            .where()
            .filter()
            .ageEqualTo(30)
            .and()
            .group((q) => q.nameEqualTo('Simon').or().ageEqualTo(20))
            .tFindAll(),
        [UserModel.fill('Simon', 30, false)],
      );
    });

    isarTest('Nested groups', () async {
      await qEqualSet(
        users
            .where()
            .filter()
            .group(
              (q) => q
                  .nameEqualTo('Simon')
                  .or()
                  .group((q) => q.ageEqualTo(30).or().ageEqualTo(20)),
            )
            .tFindAll(),
        [
          UserModel.fill('Simon', 30, false),
          UserModel.fill('David', 20, false),
          UserModel.fill('Emma', 30, true),
        ],
      );
    });
  });
}
