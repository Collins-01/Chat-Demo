import 'dart:io';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';

abstract class IChatService {
  /// [init] method is called when the the chat service is created.
  /// It should initialize the Database and the Socket.
  Future<void> init();

  ///[deleteDatabase] method is used to delete the database from the device.
  Future<void> deleteDatabase();

  /// Used to send a message to the
  Future<void> sendMessage(
      MessageModel message, ContactModel contact, File? file);

  Future<void> onMessageReceived();

  Future<void> onMessageRead();

  Future<void> emitMessageRead();
}
