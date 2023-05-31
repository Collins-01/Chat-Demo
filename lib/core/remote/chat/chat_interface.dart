import 'dart:io';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';

abstract class IChatService {
  /// [init] method is called when the the chat service is created.
  /// It should initialize the Database and the Socket.
  Future<void> init();

  ///[deleteDatabase] method is used to delete the database from the device.
  Future<void> deleteDatabase();

//* * * * * * * * * * * * * * * * * ON EVENTS  * * * * * * * * * * * *

  Future<void> onMessageReceived(Map<String, dynamic> json);

  Future<void> onMessageRead(Map<String, dynamic> json);

  Future<void> onMessageDelivered(Map<String, dynamic> json);

// * * * * * * * * * * * * * * * * * EMIT * * * * * * * * *
  /// Used to send a message to the
  Future<void> sendMessage(
      MessageModel message, ContactModel contact, File? file);
  // Future<void> emitMessageRead();
  // Future<void> emitMessageDelivered();

  Future<void> queryAndSendUnsentMessages();

  /// Returns conversation for this user from the server
  Future<void> getConversations();

  Stream<List<ContactModel>> getContactsAsStream(String pattern);

  Future insertAllContacts(List<ContactModel> contacts);
}
