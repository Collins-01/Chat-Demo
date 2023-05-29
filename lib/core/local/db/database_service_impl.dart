import 'package:harmony_chat_demo/core/local/db/database_interface.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:sqlbrite/sqlbrite.dart';

class DatabaseServiceImpl implements IDatabase {
  final BriteDatabase _streamDatabase;
  final Database _database;

  DatabaseServiceImpl(this._database)
      : _streamDatabase = BriteDatabase(_database);

  @override
  Future<int> insert(String table, Map<String, dynamic> rowData,
      [bool ignoreConflict = false]) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<void> insertAllContacts(List<ContactModel> contacts) {
    // TODO: implement insertAllContacts
    throw UnimplementedError();
  }

  @override
  Future<void> insertAllMessages(List<MessageModel> messages) {
    // TODO: implement insertAllMessages
    throw UnimplementedError();
  }

  @override
  Future<int> insertContact(ContactModel contact) {
    // TODO: implement insertContact
    throw UnimplementedError();
  }

  @override
  Future<int> insertMessage(MessageModel message) {
    // TODO: implement insertMessage
    throw UnimplementedError();
  }

  @override
  Future<void> updatContact(ContactModel contact) {
    // TODO: implement updatContact
    throw UnimplementedError();
  }

  @override
  Future<int> update(String table, Map<String, dynamic> rowData,
      {String? where, List<Object?>? whereArgs, bool ignoreConflict = false}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> updateAllContacts(List<ContactModel> contacts) {
    // TODO: implement updateAllContacts
    throw UnimplementedError();
  }

  @override
  Future<void> updateAllMessages(List<MessageModel> messages) {
    // TODO: implement updateAllMessages
    throw UnimplementedError();
  }

  @override
  Future<void> updateMessage(MessageModel message) {
    // TODO: implement updateMessage
    throw UnimplementedError();
  }

  @override
  Future<int> delete(String table, String id, {String fieldName = "id"}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<int> deleteContact(ContactModel contact) {
    // TODO: implement deleteContact
    throw UnimplementedError();
  }

  @override
  Future<int> deleteMessage(MessageModel message) {
    // TODO: implement deleteMessage
    throw UnimplementedError();
  }
}
