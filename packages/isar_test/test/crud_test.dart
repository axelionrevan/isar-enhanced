import 'package:isar/isar.dart';
import 'package:isar_test/message_model.dart';
import 'package:test/test.dart';

import 'package:isar_test/isar.g.dart';

import 'common.dart';

void main() {
  group('CRUD', () {
    late Isar isar;
    late IsarCollection<Message> messages;

    setUp(() async {
      isar = await openTempIsar();
      messages = isar.messages;
    });

    tearDown(() async {
      await isar.close();
    });

    isarTest('get() / put() without oid', () async {
      final message = Message()..message = 'This is a new message';

      await isar.writeTxn((isar) async {
        await messages.put(message);
      });

      final newMessage = await messages.get(message.id!);
      expect(message, newMessage);
    });

    isarTest('get() / put() with oid', () async {
      final message = Message()
        ..id = 5
        ..message = 'This is a new message';

      await isar.writeTxn((isar) async {
        await messages.put(message);
      });

      final newMessage = await messages.get(message.id!);
      expect(message, newMessage);

      final noMessage = await messages.get(6);
      expect(noMessage, null);
    });

    isarTest('getSync() / putSync() without int oid', () {
      final message = Message()..message = 'This is a new message';

      isar.writeTxnSync((isar) {
        messages.putSync(message);
      });

      final newMessage = messages.getSync(message.id!);
      expect(message, newMessage);
    });

    /*isarTest('getSync() / putSync() with oid', () {
      final message = Message()
        ..id = 5
        ..message = 'This is a new message';

      isar.writeTxnSync((isar) {
        messages.putSync(message);
      });

      final newMessage = messages.getSync(message.id!);
      expect(message, newMessage);

      final noMessage = messages.getSync(6);
      expect(noMessage, null);
    });

    isarTest('get() / put() null', () async {
      final user = await users.get('Nonexisting User');
      expect(user, null);
    });

    isarTest('getSync() null', () {
      final user = users.getSync('Nonexisting User');
      expect(user, null);
    });

    isarTest('getAll() / putAll()', () async {
      final message1 = Message()..message = 'Message one';
      final message2 = Message()..message = 'Message two';
      final message3 = Message()..message = 'Message three';

      await isar.writeTxn((isar) async {
        await messages.putAll([message1, message2, message3]);
      });

      final newMessages = await messages.getAll([message1.id!, message2.id!]);
      expect(newMessages, [message1, message2]);
      final newMessage3 = await messages.get(message3.id!);
      expect(newMessage3, message3);
    });

    /*isarTest('getAllSync() / putAllSync()', () {
      final message1 = Message()..message = 'Message one';
      final message2 = Message()..message = 'Message two';
      final message3 = Message()..message = 'Message three';

      isar.writeTxnSync((isar) {
        messages.putAllSync([message1, message2, message3]);
      });

      final newMessages = messages.getAllSync([message1.id!, message2.id!]);
      expect(newMessages, [message1, message2]);
      final newMessage3 = messages.getSync(message3.id!);
      expect(newMessage3, message3);
    });*/

    /*isarTest('delete()', () async {
      final user = UserModel()
        ..name = 'Some User'
        ..age = 24;

      await isar.writeTxn((isar) async {
        await users.put(user);
      });

      await isar.writeTxn((isar) async {
        await users.delete('Nonexisting User');
      });
      expect(await users.get(user.name), user);

      await isar.writeTxn((isar) async {
        await users.delete(user.name);
      });
      expect(await users.get(user.name), null);
    });

    isarTest('deleteSync()', () async {
      final user = UserModel()
        ..name = 'Some User'
        ..age = 24;

      isar.writeTxnSync((isar) {
        users.putSync(user);
      });

      isar.writeTxnSync((isar) {
        users.deleteSync('Nonexisting User');
      });
      expect(users.getSync(user.name), user);

      isar.writeTxnSync((isar) {
        users.deleteSync(user.name);
      });
      expect(users.getSync(user.name), null);
    });*/*/
  });
}
