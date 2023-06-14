import 'package:harmony_chat_demo/core/models/models.dart';

abstract class DatabaseRepository {
  Future<void> initializeDB();
  Future<void> deleteDB();

// * * * * * * * * * * * * * * * INSERT * * * * * * * * * * *

  /// Used to Create an [INSERT] action on the database.
  /// Takes in the table name and Map data.
  Future<int> insert(String table, Map<String, dynamic> rowData,
      [bool ignoreConflict = false]);

  ///Create a new contact on the `contacts` table in the database.
  Future<int> insertContact(ContactModel contact);

  /// Creates a new message on the `messages` table in the database.
  Future<int> insertMessage(MessageModel message);

  /// Inserts multiple messages on the `messages` table in the database
  Future<void> insertAllMessages(List<MessageModel> messages);

  ///Inerts multiple contacts on the `contacts` table in the database
  Future<void> insertAllContacts(List<ContactModel> contacts);

  // * * * * * * * * * * * * * * * * * UPDATE * * * * * * * * * * *

  /// Creates an `UPDATE` statement int the database
  Future<int> update(
    String table,
    Map<String, dynamic> rowData, {
    String? where,
    List<Object?>? whereArgs,
    bool ignoreConflict = false,
  });

  ///Updates a contact on the `contacts` table.
  Future<int> updateContact(ContactModel contact);

  /// Updates a  Message on the `messages` table.
  Future<int> updateMessage(MessageModel message);

  ///Updates a list of contacts on the `contacts` table.
  Future<void> updateAllContacts(List<ContactModel> contacts);

  /// Updates a list of messages on the `messages` table.
  Future<void> updateAllMessages(List<MessageModel> messages);
  Future<void> updateMessagesStatusByServerId(
      List<String> serverIds, String status);

// * * * * * * * * * * * * * DELETE * * * * * * * * * * * *

  /// Deletes a row from the table, takes in parameters [table],[id] and [fieldName]
  Future<int> delete(String table, String id, {String fieldName = "id"});

  /// Deltes a contact from the `contacts` table, takes in parameters [ContactModel]
  Future<int> deleteContact(ContactModel contact);

  /// Deletes a message from the `messages` table, takes in parameters [MessageModel]
  Future<int> deleteMessage(MessageModel message);

  // * * * * * * * * * * * * * * * * * * * * *  QUERIES * * * * * * * * * * * * * * * *

  /// get message with [id]
  Future<MessageModel?> getMessageById(String id);

  /// get message with [localId]
  Future<MessageModel?> getMessageByLocalId(String localId);

  Future<List<MessageModel>> getAllUnsentMessages(
    String userId,
  );

  /// get message with [serverid]
  Future<MessageModel?> getMessageByServerId(String serverId);

  Future<List<MessageModel>> getAllDeliveredMessagesWithUser(String receiverId);

  /// get user with [id]
  Future<ContactModel?> getContact(String id);

  Future<ContactModel?> getContactByServerId(String serverId);

  /// get list of all user contacts
  Future<List<ContactModel>> getContacts();

  ///get [contact] last message
  Future<MessageModel?> getContactLastMessage(ContactModel contact);

  /// get [contact] messages
  Future<List<MessageModel>> getContactMessages(ContactModel contact);

  /// Emits all  message messages containing a media file in conversation with
  /// this chat id -> `chatId`.
  Stream<List<MessageModel>> watchMediaMessages(String chatId);

  /// get unread messages sent by user with id [contactId]
  /// in chat with [chatId]
  Future<List<MessageModel>> getUnreadMessagesByChatId({
    required String chatId,
    required String contactId,
  });

  Future<List<MessageModel>> getMessagesWithUserByStatus({
    required String sender,
    required String receiver,
    required String status,
  });

  /// getall unsent messages
  Future<List<MessageModel>> getUnsentMessages();

  //  * * * * * * * * * * * * * * * * STREAMS  * * * * * * * * * * * * * * * * * * * * * * * *
  /// Emits when the ```contacts``` table is altered
  Stream<List<ContactModel>> watchContacts();

  /// Emits when the  ```contacts``` table is altered
  /// Only emits contacts which username match [pattern]
  Stream<List<ContactModel>> watchContactsByPattern(String pattern);

  /// Emits when the ```message``` table is altered
  Stream<List<MessageModel>> watchMessages();

  /// Emits when when there is an  with messages sent btw [contact]
  Stream<List<MessageModel>> watchContactMessages(ContactModel contact);

  /// Get all media messages that have not been completely uploaded/downloaded.
  Future<List<MessageModel>> getMediaMessagesInUploadOrDownloadState();

  Stream<List<MessageInfoModel>> getMyLastConversations(String id);
}
