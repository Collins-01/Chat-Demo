import 'package:harmony_chat_demo/core/local/chat_repository/chat_repository.dart';
import 'package:harmony_chat_demo/core/local/db/db.dart';
import 'package:harmony_chat_demo/core/local/constants/db_constants.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/utils/app_logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChatRepositoyImpl implements ChatRepository {
  final _logger = const AppLogger(ChatRepositoyImpl);
  late final DatabaseRepository _databaseRepository;

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
    _logger.i("Path to created database ::: $path ");
    return openDatabase(path,
        version: DBConstants.dbVersion, onCreate: _onCreateDatabase);
  }

  @override
  Future<void> deleteDatabase() async {
    final documentDirectory = await getDatabasesPath();
    final path = join(documentDirectory, DBConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    await _initializeDatabase();
  }

  @override
  Future<void> initialize() async {
    // _databaseRepository = DatabaseRepositoryImpl(await _initializeDatabase());
  }

  @override
  Future<void> deleteContact(ContactModel contact) async {
    await _databaseRepository.deleteContact(contact);
  }

  @override
  Future<void> deleteMessage(MessageModel message) async {
    await _databaseRepository.deleteMessage(message);
  }

  @override
  Future<ContactModel?> getContact(String id) async {
    return null;
  }

  @override
  Future<List<ContactModel>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Stream<List<ContactModel>> getContactsAsStream() {
    // TODO: implement getContactsAsStream
    throw UnimplementedError();
  }

  @override
  Future<void> insertAllContacts(List<ContactModel> contacts) {
    // TODO: implement insertAllContacts
    throw UnimplementedError();
  }

  @override
  Future<void> insertAllMessage(List<MessageModel> messages) {
    // TODO: implement insertAllMessage
    throw UnimplementedError();
  }

  @override
  Future<void> insertContact(ContactModel contact) {
    // TODO: implement insertContact
    throw UnimplementedError();
  }

  @override
  Future<void> insertMessage(MessageModel message) async {}

  @override
  Future<void> updateAllMessages(List<MessageModel> messages) {
    // TODO: implement updateAllMessages
    throw UnimplementedError();
  }

  @override
  Future<void> updateContact(ContactModel contact) {
    // TODO: implement updateContact
    throw UnimplementedError();
  }

  @override
  Future<void> updateMessage(MessageModel message) {
    // TODO: implement updateMessage
    throw UnimplementedError();
  }

  @override
  Future<int> bulkRead(
      {required DateTime date,
      required String senderId,
      required String receiverId}) {
    // TODO: implement bulkRead
    throw UnimplementedError();
  }

  @override
  Future<MessageModel?> getContactLastMessage(ContactModel contact) {
    // TODO: implement getContactLastMessage
    throw UnimplementedError();
  }

  @override
  Future<List<MessageModel>> getContactMessages(ContactModel contact) {
    // TODO: implement getContactMessages
    throw UnimplementedError();
  }

  @override
  Future<List<MessageModel>> getMediaMessagesInUploadOrDownloadState() {
    // TODO: implement getMediaMessagesInUploadOrDownloadState
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
  Stream<List<MessageModel>> watchContactMessages(ContactModel contact) {
    // TODO: implement watchContactMessages
    throw UnimplementedError();
  }

  @override
  Stream<List<MessageModel>> watchMediaMessages(String chatId) {
    // TODO: implement watchMediaMessages
    throw UnimplementedError();
  }
}
