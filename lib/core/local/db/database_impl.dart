import 'package:harmony_chat_demo/core/local/constants/contact_field.dart';
import 'package:harmony_chat_demo/core/local/constants/db_constants.dart';
import 'package:harmony_chat_demo/core/local/constants/message_field.dart';
import 'package:harmony_chat_demo/core/local/db/database_repository.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:sqlbrite/sqlbrite.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  final BriteDatabase _streamDatabase;
  final Database _database;

  DatabaseRepositoryImpl(this._database)
      : _streamDatabase = BriteDatabase(_database);

  @override
  Future<int> insert(String table, Map<String, dynamic> rowData,
      [bool ignoreConflict = false]) async {
    return _streamDatabase.insert(table, rowData,
        conflictAlgorithm: ignoreConflict
            ? ConflictAlgorithm.ignore
            : ConflictAlgorithm.replace);
  }

  @override
  Future<void> insertAllContacts(List<ContactModel> contacts) async {
    final batch = _streamDatabase.batch();
    for (var contact in contacts) {
      batch.insert(DBConstants.contactTable, contact.mapToDB());
    }
    batch.commit(noResult: true);
  }

  @override
  Future<void> insertAllMessages(List<MessageModel> messages) async {
    final batch = _streamDatabase.batch();
    for (var message in messages) {
      batch.insert(DBConstants.messageTable, message.mapToDB());
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<int> insertContact(ContactModel contact) {
    return insert(DBConstants.contactTable, contact.mapToDB(), false);
  }

  @override
  Future<int> insertMessage(MessageModel message) async {
    return insert(DBConstants.messageTable, message.mapToDB(), false);
  }

  @override
  Future<int> updateContact(ContactModel contact) async {
    return update(
      DBConstants.contactTable,
      contact.mapToDB(),
      where: "${ContactField.id} = ?",
      whereArgs: [contact.id],
    );
  }

  @override
  Future<int> update(String table, Map<String, dynamic> rowData,
      {String? where,
      List<Object?>? whereArgs,
      bool ignoreConflict = false}) async {
    return await _streamDatabase.update(
      table,
      rowData,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm:
          ignoreConflict ? ConflictAlgorithm.ignore : ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateAllContacts(List<ContactModel> contacts) {
    // TODO: implement updateAllContacts
    throw UnimplementedError();
  }

  @override
  Future<void> updateAllMessages(List<MessageModel> messages) async {
    final batch = _streamDatabase.batch();
    for (var message in messages) {
      batch.update(
        DBConstants.messageTable,
        message.mapToDB(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    batch.commit(noResult: true);
  }

  @override
  Future<int> updateMessage(MessageModel message) async {
    return update(DBConstants.messageTable, message.mapToDB(),
        where: "${MessageField.localId} = ?", whereArgs: [message.localId]);
  }

  @override
  Future<int> delete(String table, String id, {String fieldName = "id"}) {
    return _streamDatabase.delete(
      table,
      where: "$fieldName = ?",
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteContact(ContactModel contact) async {
    return delete(DBConstants.contactTable, contact.id,
        fieldName: ContactField.id);
  }

  @override
  Future<int> deleteMessage(MessageModel message) async {
    return delete(DBConstants.messageTable, message.localId,
        fieldName: MessageField.localId);
  }

  @override
  Future<ContactModel?> getContact(String id) async {
    final data = await _streamDatabase.query(
      DBConstants.contactTable,
      where: "${ContactField.id} = ?",
      whereArgs: [id],
      limit: 1,
    );
    return data.isEmpty ? null : ContactModel.fromDB(data[0]);
  }

  @override
  Future<MessageModel?> getContactLastMessage(ContactModel contact) async {
    final data = await _streamDatabase.query(
      DBConstants.messageTable,
      limit: 1,
      where: "${MessageField.sender} = ? OR ${MessageField.receiver} = ?",
      whereArgs: [contact.id, contact.id],
    );
    return data.isEmpty ? null : MessageModel.fromDB(data[0]);
  }

  @override
  Future<List<MessageModel>> getContactMessages(ContactModel contact) async {
    // final data = await _streamDatabase.query(DBConstants.messageTable);
    return [];
  }

  @override
  Future<List<ContactModel>> getContacts() async {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Future<MessageModel?> getMessageById(String id) {
    // TODO: implement getMessageById
    throw UnimplementedError();
  }

  @override
  Future<MessageModel?> getMessageByLocalId(String localId) {
    // TODO: implement getMessageByLocalId
    throw UnimplementedError();
  }

  @override
  Future<List<MessageModel>> getUnreadMessagesByChatId(
      {required String chatId, required String contactId}) {
    // TODO: implement getUnreadMessagesByChatId
    throw UnimplementedError();
  }

  @override
  Future<List<MessageModel>> getUnsentMessages() {
    // TODO: implement getUnsentMessages
    throw UnimplementedError();
  }

  @override
  Stream<List<MessageModel>> watchMediaMessages(String chatId) {
    // TODO: implement watchMediaMessages
    throw UnimplementedError();
  }

  @override
  Future<List<MessageModel>> getMediaMessagesInUploadOrDownloadState() {
    // TODO: implement getMediaMessagesInUploadOrDownloadState
    throw UnimplementedError();
  }

  @override
  Stream<List<MessageModel>> watchContactMessages(ContactModel contact) {
    // TODO: implement watchContactMessages
    throw UnimplementedError();
  }

  @override
  Stream<List<ContactModel>> watchContacts() {
    // TODO: implement watchContacts
    throw UnimplementedError();
  }

  @override
  Stream<List<ContactModel>> watchContactsByPattern(String pattern) {
    // TODO: implement watchContactsByPattern
    throw UnimplementedError();
  }

  @override
  Stream<List<MessageModel>> watchMessages() {
    // TODO: implement watchMessages
    throw UnimplementedError();
  }
}
