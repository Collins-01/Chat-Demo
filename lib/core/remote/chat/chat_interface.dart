import 'dart:io';
import 'package:harmony_chat_demo/core/models/models.dart';

abstract class IChatService {
  /// [init] method is called when the the chat service is created.
  /// It should initialize the Database and the Socket.
  Future<void> init();

  ///[deleteDatabase] method is used to delete the database from the device.

//* * * * * * * * * * * * * * * * * ON EVENTS  * * * * * * * * * * * *

  Future<void> onMessageReceived(Map<String, dynamic> json);

  Future<void> onMessageRead(Map<String, dynamic> json);

  Future<void> onMessageDelivered(Map<String, dynamic> json);
  Future<void> onMessageSent(Map<String, dynamic> json);

// * * * * * * * * * * * * * * * * * EMIT * * * * * * * * *
  /// Used to send a message to the
  Future<void> sendMessage(
      MessageModel message, ContactModel contact, File? file);
  // Future<void> emitMessageRead();
  // Future<void> emitMessageDelivered();

  Future<void> queryAndSendUnsentMessages();

  Future<void> emitMessageDelivered(int severId);

  /// Returns conversation for this user from the server
  Future<void> getConversations();

  Stream<List<MessageModel>> watchMessages();

  Stream<List<MessageModel>> watchMessagesWithContact(ContactModel contact);
  Stream<List<MessageInfoModel>> getMyLastConversations();
}
