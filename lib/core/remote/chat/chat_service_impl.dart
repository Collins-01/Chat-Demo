import 'package:faker/faker.dart';
import 'package:harmony_chat_demo/core/enums/message_type.dart';
import 'package:harmony_chat_demo/core/local/chat_repository/chat_repository.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'dart:io';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatServiceImpl implements IChatService {
  final ChatRepository _chatRepository;
  var faker = Faker();
  late Socket _socket;

  ChatServiceImpl({ChatRepository? chatRepository})
      : _chatRepository = chatRepository ?? locator();

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
  Future<void> deleteDatabase() async {
    await _chatRepository.deleteDatabase();
  }

  @override
  Future<void> emitMessageRead() {
    // TODO: implement emitMessageRead
    throw UnimplementedError();
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
    await _chatRepository.insertMessage(message);
  }

  @override
  Stream<List<ContactModel>> getContactsAsStream(String pattern) async* {
    yield* _chatRepository.getContactsAsStream();
  }

  @override
  Future insertAllContacts(List<ContactModel> contacts) async {
    var list = [
      ...List.generate(
        10,
        (index) => ContactModel(
          lastName: faker.person.lastName(),
          firstName: faker.person.firstName(),
          avatarUrl: faker.image.image(),
        ),
      )
    ];
    await _chatRepository.insertAllContacts(list);
  }
}
