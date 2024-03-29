import 'package:harmony_chat_demo/core/local/constants/contact_field.dart';
import 'package:harmony_chat_demo/core/local/constants/db_constants.dart';
import 'package:harmony_chat_demo/core/local/constants/message_field.dart';
import 'package:harmony_chat_demo/core/local/db/database_repository.dart';
import 'package:harmony_chat_demo/core/models/models.dart';
import 'package:path/path.dart';
import 'package:sqlbrite/sqlbrite.dart';

import '../../../utils/app_logger.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  final _logger = const AppLogger(DatabaseRepositoryImpl);

  late BriteDatabase _streamDatabase;
  late Database _database;

  _onCreateDatabase(Database db, int verserion) async {
    // Creates a `contacts` table in the newly created database.
    await db.execute(DBConstants.createContactsTable);

    // create  a `messages` table in the newly created database.
    await db.execute(DBConstants.createMessagesTable);
  }

  Future<Database> _initializeDatabase() async {
    // Get the directory for the database.
    final documentDirectory = await getDatabasesPath();
    // Create a path for the database, with the name of the database from the db_constants.
    final path = join(documentDirectory, DBConstants.databaseName);
    // _logger.i("Path to created database ::: $path ");
    return openDatabase(path,
        version: DBConstants.dbVersion, onCreate: _onCreateDatabase);
  }

  @override
  Future<void> deleteDB() async {
    final documentDirectory = await getDatabasesPath();
    final path = join(documentDirectory, DBConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    await _initializeDatabase();
  }

  @override
  Future<void> initializeDB() async {
    final db = await _initializeDatabase();
    _database = db;
    _streamDatabase = BriteDatabase(db);
  }

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
      // _logger.i(contact.toString());
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
  Future<MessageModel?> getMessageById(String id) async {
    final data = await _database.query(DBConstants.messageTable,
        where: '${MessageField.id} = ?', whereArgs: [id]);
    if (data.isEmpty) {
      _logger.e("No message with id = $id found locally");
      return null;
    }
    return MessageModel.fromDB(data[0]);
  }

  @override
  Future<MessageModel?> getMessageByLocalId(String localId) async {
    final data = await _database.query(DBConstants.messageTable,
        where: '${MessageField.localId} = ?', whereArgs: [localId]);
    if (data.isEmpty) {
      _logger.e("No message with localId = $localId found locally");
      return null;
    }
    return MessageModel.fromDB(data[0]);
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
  Stream<List<MessageModel>> watchContactMessages(ContactModel contact) async* {
    yield* _streamDatabase
        .createQuery(
      DBConstants.messageTable,
      where: "${MessageField.sender} = ? or ${MessageField.receiver} = ?",
      whereArgs: [
        contact.serverId,
        contact.serverId,
      ],
      orderBy: MessageField.updatedAt,
    )
        .mapToList(
      (row) {
        _logger
            .i("Local Message for ${contact.firstName}==> ${row.toString()}");
        return MessageModel.fromDB(row);
      },
    );
  }

  @override
  Stream<List<ContactModel>> watchContacts() async* {
    final stream = _streamDatabase.createRawQuery(
      [DBConstants.contactTable],
      DBConstants.contactRawQuery(),
    );
    yield* stream.mapToList((row) => ContactModel.fromDB(row));
  }

  @override
  Stream<List<ContactModel>> watchContactsByPattern(String pattern) {
    // TODO: implement watchContactsByPattern
    throw UnimplementedError();
  }

  @override
  Stream<List<MessageModel>> watchMessages() async* {
    yield* _streamDatabase.createQuery(DBConstants.messageTable).mapToList(
          (row) => MessageModel.fromDB(row),
        );
  }

  @override
  Stream<List<MessageInfoModel>> getMyLastConversations(String id) async* {
    yield* _streamDatabase.createRawQuery(
      [DBConstants.messageTable, DBConstants.contactTable],
      ''' 
      SELECT 
            c.${ContactField.id},
            c.${ContactField.lastName},
            c.${ContactField.firstName},
            c.${ContactField.avatar},
            c.${ContactField.serverId},
            m.${MessageField.content},
            m.${MessageField.updatedAt},
            m.${MessageField.status},
            m.${MessageField.messageType},
            m.${MessageField.sender},
            m.${MessageField.receiver},
            m.${MessageField.id},
            (
              SELECT COUNT(*) FROM ${DBConstants.messageTable} WHERE ${MessageField.receiver} = ? AND ${MessageField.status} = '${MessageStatus.delivered}' AND ${MessageField.isDeleted} = '0'
            ) AS unreadMessagesCount

            FROM 

            ${DBConstants.contactTable} AS c
            
            JOIN ${DBConstants.messageTable} AS m ON ( 
              m.${MessageField.sender} = ?  OR  m.${MessageField.receiver} = ?
            ) 

            WHERE  m.${MessageField.updatedAt} = ( 
              
              SELECT MAX(${MessageField.updatedAt}) FROM ${DBConstants.messageTable} 
               WHERE
                (
                  m.${MessageField.sender} = ?
                  OR m.${MessageField.receiver} = ?
                )
             )
              AND ${MessageField.isDeleted} = '0'
              
              ORDER BY
            m.${MessageField.updatedAt} DESC;
          ''',
      [id, id, id, id, id],
    ).mapToList((row) {
      // _logger.d("Watching recent conversations :: ${row.toString()}");
      return MessageInfoModel.fromDB(row);
    });
  }

  @override
  Future<MessageModel?> getMessageByServerId(String serverId) async {
    final data = await _database.query(DBConstants.messageTable,
        where: '${MessageField.serverId} = ?', whereArgs: [serverId]);
    if (data.isEmpty) {
      _logger.e("No message with ServerId = $serverId found locally");
      return null;
    }
    return MessageModel.fromDB(data[0]);
  }

  @override
  Future<List<MessageModel>> getAllDeliveredMessagesWithUser(
      String receiverId) async {
    final data = _streamDatabase.createQuery(
      DBConstants.messageTable,
      where: '${MessageField.receiver} = ? AND ${MessageField.status} = ?',
      whereArgs: [receiverId, MessageStatus.delivered],
    );
    return [];
  }

  @override
  Future<ContactModel?> getContactByServerId(String serverId) async {
    final data = await _streamDatabase.query(
      DBConstants.contactTable,
      where: "${ContactField.serverId} = ?",
      whereArgs: [serverId],
      limit: 1,
    );
    return data.isEmpty ? null : ContactModel.fromDB(data[0]);
  }

  @override
  Future<List<MessageModel>> getMessagesWithUserByStatus({
    required String sender,
    required String receiver,
    required String status,
  }) async {
    final response = await _streamDatabase.query(
      DBConstants.messageTable,
      where:
          '${MessageField.receiver} = ? AND ${MessageField.sender} = ? AND ${MessageField.status} = ? ',
      whereArgs: [receiver, sender, status],
    );

    return response.map((e) => MessageModel.fromDB(e)).toList();
  }

  @override
  Future<void> updateMessagesStatusByServerId(
      List<String> serverIds, String status) async {
    _logger.d("Called --> updateMessagesStatusByServerId <-- ::");
    // ${serverIds.map((_) => '?').join(', ')
    await _database.rawUpdate(
      '''
        UPDATE ${DBConstants.messageTable} 
        SET ${MessageField.status} = ? 
        WHERE  ${MessageField.serverId} IN (${serverIds.map((_) => '?').join(', ')})
      ''',
      [status, ...serverIds],
    );
  }

  @override
  Future<List<MessageModel>> getAllUnsentMessages(String userId) async {
    final data = await _streamDatabase.rawQuery(
      '''
        SELECT * FROM ${DBConstants.messageTable}
        WHERE ${MessageField.status} = ? AND ${MessageField.sender} = ?
     ''',
      [
        MessageStatus.unsent,
        userId,
      ],
    );
    if (data.isEmpty) {
      return [];
    }

    return data.map((e) => MessageModel.fromDB(e)).toList();
  }

  @override
  Stream<List<MessageModel>> searchChat(String query,
      {required String sender, required String receiver}) async* {
    yield* _streamDatabase.createRawQuery(
      [DBConstants.messageTable],
      '''
      SELECT * FROM ${DBConstants.messageTable}
      WHERE 
       ${MessageField.sender} = ?  AND ${MessageField.receiver} = ? AND ${MessageField.isDeleted} = '0'  AND ${MessageField.content} LIKE '%?%';
      ''',
      [sender, receiver, query],
    ).mapToList((row) => MessageModel.fromDB(row));
  }
}
