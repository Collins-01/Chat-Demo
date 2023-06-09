import 'dart:io';
import 'package:harmony_chat_demo/core/models/models.dart';

abstract class IChatService {
  /// [init] method is called when the the chat service is created.
  /// It should initialize the Database and the Socket.
  Future<void> init();

  ///[deleteDatabase] method is used to delete the database from the device.

//* * * * * * * * * * * * * * * * * ON EVENTS  * * * * * * * * * * * *

  /// This Method listens to new messages from the server, and then saves the message.
  Future<void> onMessageReceived(Map<String, dynamic> json);

  Future<void> onMessageRead(Map<String, dynamic> json);

  /// This method is called when a message get delivered successfully to the client.
  Future<void> onMessageDelivered(Map<String, dynamic> json);

  /// This method is called when a message gets read the receiver
  Future<void> onMessageSent(Map<String, dynamic> json);

  Future<void> onMessageDeleted(Map<String, dynamic> json);

// * * * * * * * * * * * * * * * * * EMIT * * * * * * * * *
  /// Used to send a message to the
  Future<void> sendMessage(
      MessageModel message, ContactModel contact, File? file);
  Future<void> emitMessageRead(int serverId);
  // Future<void> emitMessageDelivered();

  Future<void> queryAndSendUnsentMessages();

  Future<void> emitMessageDelivered(int severId);
  Future<void> emitDeleteMessage(int severId);

  Future<void> emitBulkRead(String receiverId);

  /// Returns conversation for this user from the server
  Future<void> getConversations();

  Stream<List<MessageModel>> watchMessages();

  Stream<List<MessageModel>> watchMessagesWithContact(ContactModel contact);
  Stream<List<MessageInfoModel>> getMyLastConversations();
}
