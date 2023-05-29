import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';

abstract class IDatabase {
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
  Future<void> updatContact(ContactModel contact);

  /// Updates a  Message on the `messages` table.
  Future<void> updateMessage(MessageModel message);

  ///Updates a list of contacts on the `contacts` table.
  Future<void> updateAllContacts(List<ContactModel> contacts);

  /// Updates a list of messages on the `messages` table.
  Future<void> updateAllMessages(List<MessageModel> messages);

// * * * * * * * * * * * * * DELETE * * * * * * * * * * * *

  /// Deletes a row from the table, takes in parameters [table],[id] and [fieldName]
  Future<int> delete(String table, String id, {String fieldName = "id"});

  /// Deltes a contact from the `contacts` table, takes in parameters [ContactModel]
  Future<int> deleteContact(ContactModel contact);

  /// Deletes a message from the `messages` table, takes in parameters [MessageModel]
  Future<int> deleteMessage(MessageModel message);
}
