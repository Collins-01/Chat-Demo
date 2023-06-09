import 'dart:async';

import 'package:harmony_chat_demo/core/local/db/database_repository.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/media_type.dart';
import 'package:harmony_chat_demo/core/models/message_info_model.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'dart:io';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:harmony_chat_demo/core/remote/contacts/contact_service_interface.dart';
import 'package:harmony_chat_demo/services/files/file_service_interface.dart';
import 'package:harmony_chat_demo/utils/app_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../models/message_type.dart';

class ChatServiceImpl implements IChatService {
  final DatabaseRepository _databaseRepository;
  final IContactService _contactService;
  final IFileService _fileService;
  final IAuthService _authService;
  final _logger = const AppLogger(ChatServiceImpl);

  late Socket _socket;

  ChatServiceImpl(
      {DatabaseRepository? databaseRepository,
      IAuthService? authService,
      IContactService? contactService,
      IFileService? fileService})
      : _databaseRepository = databaseRepository ?? locator(),
        _contactService = contactService ?? locator(),
        _fileService = fileService ?? locator(),
        _authService = authService ?? locator();

  final String _messageEvent = 'MESSAGE';
  final String _messageSentEvent = 'MESSAGE_SENT';
  final String _messageDelivered = 'DELIVERED';
  final String _messageDeliveredAck = 'DELIVERED_ACK';

  @override
  Future<void> init() async {
    _socket = io('http://localhost:3000/messaging', {
      'transports': ['websocket'],
      "forceNew": true,
      "extraHeaders": {
        'authorization': _authService.accessToken!,
      }
    });
    _socket.onConnect((data) {
      _logger.d("On Socket Connect: $data");
    });
    _socket.onReconnect(
      (_) {
        _logger.d("Socket Reconnecting........");
      },
    );
    _socket.onDisconnect(
      (data) {
        _logger.e("Socket Disconnected......");
        _logger.e(data);
      },
    );
    _socket.onConnectError(
      (data) {
        _logger.i("Socket Connect Error");
        _logger.i(data);
      },
    );
    _socket.on(_messageEvent, (data) {
      _logger.d("On Message Event::: $data ", functionName: _messageEvent);
      onMessageReceived(data);
    });
    _socket.on(_messageSentEvent, (data) {
      _logger.d(
        "On Message Sent Event :: $data",
      );
      onMessageSent(data);
    });
    _socket.connect();
    _logger.d("Socket Connected::: ${_socket.connected}");
    Timer timer;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_socket.connected) {
        _logger.d("Trying to reconnect to socket...");
        _socket.connect();
      } else {
        timer.cancel();
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
      case MessageType.audio:
        _sendAudioMessage(message, contact, file!);
        break;
      case MessageType.image:
        _sendImageMessage(message, contact, file!);
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
  Future<void> onMessageDelivered(Map<String, dynamic> json) async {
    final data = json['data'];
    final message =
        await _databaseRepository.getMessageByServerId(data['server_id']);
    if (message != null) {
      await _databaseRepository.updateMessage(
        message.copyWith(
          status: data['status'],
        ),
      );
    }
    _logger.e("Message with local id ${data['local_id']} not found ..");
  }

  @override
  Future<void> queryAndSendUnsentMessages() {
    // TODO: implement queryAndSendUnsentMessages
    throw UnimplementedError();
  }

  @override
  Future<void> onMessageRead(Map<String, dynamic> json) async {}

  @override
  Future<void> onMessageReceived(Map<String, dynamic> json) async {
    final data = json['data'];
    final MessageModel message = MessageModel.fromMap(data);
    await _databaseRepository.insertMessage(message);
    emitMessageDelivered(message.serverId!);
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
    final savedMessage = await _databaseRepository.getMessageById(message.id!);
    if (savedMessage == null) {
      _logger.e("Saved Message with id = ${message.id} Not found ...");
    }
    _socket.emit(_messageEvent, savedMessage!.mapToServerDB());
  }

  void _sendAudioMessage(
      MessageModel message, ContactModel contact, File audioFile) async {
    final receiverContact = await _contactService.getContact(contact
        .id); //TODO: Check for the server id later. Use local contact id for now.
    if (receiverContact == null) {
      _logger.e(
        "receiverContact Id not found in local db",
      );
    }
    await _databaseRepository.insertMessage(message);
    // * Change Media Uploading State to true
    var savedMsg = await _databaseRepository.getMessageById(message.id!);
    _logger.d("Saved Message Fectched by Id :: ${savedMsg?.mapToDB()}");
    final mediaUrl = await _fileService.uploadFile(audioFile, MediaType.audio);
    if (mediaUrl != null) {
      await _databaseRepository.updateMessage(
        savedMsg!.copyWith(mediaUrl: mediaUrl),
      );
      _socket.emit(
        _messageEvent,
        () => savedMsg.copyWith(mediaUrl: mediaUrl),
      );
    } else {
      await _databaseRepository.updateMessage(
        savedMsg!.copyWith(failedToUploadMedia: true),
      );
    }
  }

  void _sendImageMessage(
      MessageModel message, ContactModel contact, File imageFile) async {
    final receiverContact = await _contactService.getContact(contact.id);
    if (receiverContact == null) {
      _logger.e(
        "Receiver Contact Id not found in local db",
      );
    }
    await _databaseRepository.insertMessage(message);
    // * Change Media Uploading State to true
    var savedMsg = await _databaseRepository.getMessageById(message.id!);
    _logger.d("Saved Message Fectched by Id :: ${savedMsg?.mapToDB()}");
    final mediaUrl = await _fileService.uploadFile(imageFile, MediaType.image);
    if (mediaUrl != null) {
      await _databaseRepository.updateMessage(
        savedMsg!.copyWith(mediaUrl: mediaUrl),
      );
      _socket.emit(
        _messageEvent,
        () => savedMsg.copyWith(mediaUrl: mediaUrl),
      );
    } else {
      await _databaseRepository.updateMessage(
        savedMsg!.copyWith(failedToUploadMedia: true),
      );
    }
  }

  @override
  Stream<List<MessageModel>> watchMessages() async* {
    yield* _databaseRepository.watchMessages();
  }

  @override
  Stream<List<MessageModel>> watchMessagesWithContact(
      ContactModel contact) async* {
    yield* _databaseRepository.watchContactMessages(contact);
  }

  @override
  Stream<List<MessageInfoModel>> getMyLastConversations() async* {
    final id = _contactService.userContactInfo!.id;
    yield* _databaseRepository.getMyLastConversations(id);
  }

  @override
  Future<void> onMessageSent(Map<String, dynamic> json) async {
    final data = json['data'];
    final message = await _databaseRepository
        .getMessageByLocalId(data['local_id'] as String);
    if (message != null) {
      await _databaseRepository.updateMessage(
        message.copyWith(
          status: data['status'],
          serverId: data['server_id'],
        ),
      );
    }
    _logger.e("No Message found for localId ${data['local_id']}");
  }

  @override
  Future<void> emitMessageDelivered(int serverId) async {
    _socket.emit(_messageDelivered, {
      "id": serverId,
    });
    _logger.d("Emitting Message Delivered for serverId : $serverId");
  }
}
