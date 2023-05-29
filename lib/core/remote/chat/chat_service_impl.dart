import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'dart:io';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatServiceImpl implements IChatService {
  late Socket _socket;

  @override
  Future<void> init() async {
    _socket = io('', {
      'transports': ['websocket'],
      "forceNew": true,
      "extraHeaders": {
        'authorization': 'token',
      }
    });
  }

  @override
  Future<void> deleteDatabase() {
    // TODO: implement deleteDatabase
    throw UnimplementedError();
  }

  @override
  Future<void> emitMessageRead() {
    // TODO: implement emitMessageRead
    throw UnimplementedError();
  }

  @override
  Future<void> onMessageRead() {
    // TODO: implement onMessageRead
    throw UnimplementedError();
  }

  @override
  Future<void> onMessageReceived() {
    // TODO: implement onMessageReceived
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(
      MessageModel message, ContactModel contact, File? file) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
