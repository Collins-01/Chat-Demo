import 'dart:async';

import 'package:harmony_chat_demo/core/local/db/database_repository.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/media_type.dart';
import 'package:harmony_chat_demo/core/models/message_info_model.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/message_status.dart';
import 'package:harmony_chat_demo/core/network_service/network_client.dart';
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
  final String _messageReadEvent = 'MESSAGE_READ_EVENT';
  final String _messageReadAck = 'MESSAGE_READ_ACK';
  final String _messageDeleteEvent = 'DELETE_MESSAGE';
  final String _messageBulkRead = 'BULK_READ';
  final String _messageBulkReadAck = 'BULK_READ_ACK';

  @override
  Future<void> init() async {
    _socket = io('${NetworkClient.baseUrl}/messaging', {
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
    /*
      This channel listens for incoming messages.
    */
    _socket.on(_messageEvent, (data) {
      _logger.d("On Message Event Received::: $data ",
          functionName: _messageEvent);
      onMessageReceived(data);
    });
    /*
    This Channel listens for every successfuly saved message on the database, and updates the 
    local message with the  server generated id
    */
    _socket.on(_messageSentEvent, (data) {
      _logger.d(
        "On Message Sent Event :: $data",
      );
      onMessageSent(data);
    });
    /*
    When a message has been successfully delivered to the receiver, the status of the message will be updated locally.
    i.e for the sender to know the status of the message sent.
    */
    _socket.on(_messageDeliveredAck, (data) {
      onMessageDeliveredAck(data);
    });
    /*
  This method listens for messages read by the other client, and updates the status locally.
  */
    _socket.on(_messageReadAck, (data) {
      onMessageRead(data);
    });

// When a sender deletes a message
    _socket.on(_messageDeleteEvent, (data) {
      onMessageDeleted(data);
    });

    _socket.on(_messageBulkReadAck, (data) {
      _logger.i("_messageBulkReadAck ==> ${data.toString()}");
      onBulkRead(data);
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
  Future<void> getConversations() {
    // TODO: implement getConversations
    throw UnimplementedError();
  }

  @override
  Future<void> queryAndSendUnsentMessages() {
    // TODO: implement queryAndSendUnsentMessages
    throw UnimplementedError();
  }

  void _sendTextMessage(MessageModel message, ContactModel contact) async {
    final user = await _contactService.getContactByServerId(contact.serverId);
    if (user == null) {
      _logger.e(
        "User Id not found in local db",
      );
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
    final receiverContact =
        await _contactService.getContactByServerId(contact.serverId);
    if (receiverContact == null) {
      _logger.e(
        "receiverContact Id not found in local db",
      );
    }
    await _databaseRepository.insertMessage(message);
    var savedMsg = await _databaseRepository.getMessageById(message.id!);
    if (savedMsg == null) {
      _logger.e(
          "Message with id : ${message.id} Not found locally. Therefore, audio message can not be sent...",
          functionName: '_sendAudioMessage');
      return;
    }
    await _databaseRepository
        .updateMessage(savedMsg.copyWith(isUploadingMedia: true));
    try {
      final uploadResponse =
          await _fileService.uploadFile(audioFile, MediaType.audio);
      await _databaseRepository.updateMessage(
        savedMsg.copyWith(
          mediaUrl: uploadResponse.mediaUrl,
          mediaId: uploadResponse.mediaId,
          isUploadingMedia: false,
        ),
      );
      _socket.emit(
        _messageEvent,
        () => {
          ...savedMsg.mapToServerDB(),
          'media_id': uploadResponse.mediaId,
          'media_url': uploadResponse.mediaUrl,
        },
      );
    } catch (e) {
      await _databaseRepository.updateMessage(savedMsg.copyWith(
          isUploadingMedia: false, failedToUploadMedia: true));
    }
  }

  void _sendImageMessage(
      MessageModel message, ContactModel contact, File imageFile) async {
    final receiverContact =
        await _contactService.getContactByServerId(contact.serverId);
    if (receiverContact == null) {
      _logger.e(
        "receiverContact Id not found in local db",
      );
    }
    final localMediaPath =
        await _fileService.copyFileToApplicationDirectory(imageFile);
    await _databaseRepository.insertMessage(
      message.copyWith(localMediaPath: localMediaPath),
    );
    var savedMsg = await _databaseRepository.getMessageById(message.id!);
    if (savedMsg == null) {
      _logger.e(
          "Message with id : ${message.id} Not found locally. Therefore, image  message can not be sent...",
          functionName: '_sendImageMessage');
      return;
    }
    await _databaseRepository
        .updateMessage(savedMsg.copyWith(isUploadingMedia: true));
    try {
      final uploadResponse =
          await _fileService.uploadFile(imageFile, MediaType.image);
      await _databaseRepository.updateMessage(
        savedMsg.copyWith(
          mediaUrl: uploadResponse.mediaUrl,
          mediaId: uploadResponse.mediaId,
          isUploadingMedia: false,
        ),
      );
      _socket.emit(
        _messageEvent,
        () => {
          ...savedMsg.mapToServerDB(),
          'media_id': uploadResponse.mediaId,
          'media_url': uploadResponse.mediaUrl,
        },
      );
    } catch (e) {
      await _databaseRepository.updateMessage(savedMsg.copyWith(
          isUploadingMedia: false, failedToUploadMedia: true));
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

// ********************   MESSAGE SENT ********************************
  @override
  Future<void> onMessageSent(Map<String, dynamic> json) async {
    final data = json['data'];
    final message = await _databaseRepository.getMessageByLocalId(
      data['local_id'] as String,
    );
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
  Future<void> onMessageReceived(Map<String, dynamic> json) async {
    final data = json['data'];
    final MessageModel message = MessageModel.fromMap(data);
    await _databaseRepository.insertMessage(message);
    emitMessageDelivered(message.serverId!);
    if (message.messageType != MessageType.text) {
      final savedMessage =
          await _databaseRepository.getMessageById(message.id!);
      if (savedMessage == null) {
        _logger.e("Saved Message not found: ");
        return;
      }
      savedMessage.copyWith(isDownloadingMedia: true);
      final localMediaPath = await _fileService.downloadFile(
        message.mediaUrl!,
      );
      if (localMediaPath != null) {
        savedMessage.copyWith(
          isDownloadingMedia: false,
          failedToDownloadMedia: false,
          localMediaPath: localMediaPath,
        );
      }
      savedMessage.copyWith(
          isDownloadingMedia: false, failedToDownloadMedia: true);
    }
    return;
  }
  // ****************************** MESSAGE DELIVERED ****************************

  @override
  Future<void> emitMessageDelivered(int serverId) async {
    _socket.emit(_messageDelivered, {
      "id": serverId,
    });
    _logger.d("Emitting Message Delivered for serverId : $serverId");
  }

  @override
  Future<void> onMessageDeliveredAck(Map<String, dynamic> json) async {
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

// ************************* MESSAGE READ  ************************************************
  @override
  Future<void> emitMessageRead(int serverId) async {
    final message =
        await _databaseRepository.getMessageByServerId(serverId.toString());
    if (message != null) {
      _socket.emit(_messageReadEvent, {
        'id': serverId,
      });
    }
    _logger.e("Message with ID :$serverId");
  }

  @override
  Future<void> onMessageRead(Map<String, dynamic> json) async {
    final data = json['data'];
    final id = data['server_id'] as int;
    final message =
        await _databaseRepository.getMessageByServerId(id.toString());
    if (message != null) {
      await _databaseRepository.updateMessage(
        message.copyWith(status: MessageStatus.read),
      );
    }
    _logger.e("Message with server id $id Not found locally.");
  }

  @override
  Future<void> emitBulkRead(String receiverId) async {
    final messages = await _databaseRepository.getMessagesWithReceiverByStatus(
      sender: _authService.user!.id,
      receiver: receiverId,
      status: MessageStatus.delivered,
    );
    if (messages.isNotEmpty) {
      final ids = messages.map((e) => e.serverId!).toList();
      _socket.emit(_messageBulkRead, {
        "server_ids": ids,
      });
    }
    return;
  }

  @override
  Future<void> onBulkRead(Map<String, dynamic> json) async {
    final data = json['data'];
    final ids = data['message_ids'] as List<int>;
    if (ids.isNotEmpty) {
      await _databaseRepository.updateMessagesStatusByServerId(
          ids, MessageStatus.read);
    }
    return;
  }

  // ********************** DELETE MESSAGE ****************************************************

  @override
  Future<void> emitDeleteMessage(int serverId) async {
    final message =
        await _databaseRepository.getMessageByServerId(serverId.toString());
    if (message != null) {
      await _databaseRepository
          .updateMessage(message.copyWith(isDeleted: true));
      _socket.emit(_messageDeleteEvent, {
        'id': message.id,
      });
    }
    _logger.e("Failed to find message with serverId :$serverId for deletion");
  }

  @override
  Future<void> onMessageDeleted(Map<String, dynamic> json) async {
    final data = json['data'];
    final id = data['messsage_id'];
    final message =
        await _databaseRepository.getMessageByServerId(id.toString());

    if (message != null) {
      await _databaseRepository.updateMessage(
        message.copyWith(isDeleted: true),
      );
    }
    _logger.e(
        "Failed to delete message with serverId : $id, because id was not found locally");
  }
}
