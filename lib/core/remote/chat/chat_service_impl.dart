import 'package:faker/faker.dart';
import 'package:harmony_chat_demo/core/enums/message_type.dart';
import 'package:harmony_chat_demo/core/local/db/database_repository.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'dart:io';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:harmony_chat_demo/core/remote/contacts/contact_service_interface.dart';
import 'package:harmony_chat_demo/utils/app_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatServiceImpl implements IChatService {
  final DatabaseRepository _databaseRepository;
  final IContactService _contactService;
  final _logger = const AppLogger(ChatServiceImpl);
  var faker = Faker();
  late Socket _socket;

  ChatServiceImpl(
      {DatabaseRepository? databaseRepository, IContactService? contactService})
      : _databaseRepository = databaseRepository ?? locator(),
        _contactService = contactService ?? locator();

  final String _messageEvent = 'MESSAGE';

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
  Future<void> sendMessage(
      MessageModel message, ContactModel contact, File? file) async {
    switch (message.messageType) {
      case MessageType.text:
        _sendTextMessage(message, contact);
        break;
      default:
    }
  }

  @override
  Future<void> getConversations() {
    // TODO: implement getConversations
    throw UnimplementedError();
  }

  @override
  Future<void> onMessageDelivered(Map<String, dynamic> json) {
    // TODO: implement onMessageDelivered
    throw UnimplementedError();
  }

  @override
  Future<void> queryAndSendUnsentMessages() {
    // TODO: implement queryAndSendUnsentMessages
    throw UnimplementedError();
  }

  @override
  Future<void> onMessageRead(Map<String, dynamic> json) {
    // TODO: implement onMessageRead
    throw UnimplementedError();
  }

  @override
  Future<void> onMessageReceived(Map<String, dynamic> json) {
    // TODO: implement onMessageReceived
    throw UnimplementedError();
  }

  void _sendTextMessage(MessageModel message, ContactModel contact) async {
    final user = await _contactService.getContact(contact.serverId);
    if (user == null) {
      _logger.e(
        "User Id not found in local db",
      );
      // * Query the user from the server and save
    }
    await _databaseRepository.insertMessage(message);
  }
}
