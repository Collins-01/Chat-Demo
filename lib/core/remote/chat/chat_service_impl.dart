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
  final String _unsentMessages = 'UNSENT_MESSAGES';
  final String _messageSentEvent = 'MESSAGE_SENT';
  final String _messageDelivered = 'DELIVERED';
  final String _messageDeliveredAck = 'DELIVERED_ACK';
  final String _messageReadEvent = 'MESSAGE_READ_EVENT';
  final String _messageReadAck = 'MESSAGE_READ_ACK';
  final String _messageDeleteEvent = 'DELETE_MESSAGE';
  final String _messageBulkRead = 'BULK_READ';
  final String _messageBulkReadAck = 'BULK_READ_ACK';
  final String _onConnectMessagesEvent = 'ON_CONNECT_MESSAGES';

  final StreamController<ContactModel?> _currentChat =
      StreamController<ContactModel?>.broadcast(sync: false);

  @override
  Future<void> init() async {
    _socket = io('${NetworkClient.baseUrl}/messaging', {
      'transports': ['websocket'],
      "forceNew": true,
      "extraHeaders": {
        'authorization': _authService.accessToken!,
      }
    });
    _socket.onConnect((data) async {
      _logger.d("On Socket Connect: $data");
      await queryAndSendUnsentMessages();
    });
    _socket.onReconnect(
      (_) async {
        _logger.d("Socket Reconnecting........");
        await queryAndSendUnsentMessages();
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

    _socket.on(_onConnectMessagesEvent, (data) {
      _logger.d("Received messages on socket connection");
      receiveMessagesOnSocketConnect(data);
    });
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
    final currentChatStream = _currentChat.stream;
    currentChatStream.listen((value) {
      if (value != null) {
        //Emit Read for messages with status 'delivered' using the contact's serverId as the receiverId
        emitBulkRead(value.serverId);
      }
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
  Future<void> queryAndSendUnsentMessages() async {
    final userId = _authService.user!.id;
    final messages = await _databaseRepository.getAllUnsentMessages(userId);
    if (messages.isNotEmpty) {
      _socket.emit(_unsentMessages, [
        ...messages.map((message) {
          return {
            'local_id': message.localId,
            'message_type': message.messageType,
            'content': message.content,
            'receiver_id': message.receiver,
          };
        }).toList()
      ]);
    } else {
      _logger.d("Yikes🥲! No unsent messages available for user");
    }
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

    try {
      await _databaseRepository
          .updateMessage(savedMsg.copyWith(isUploadingMedia: true));
      final uploadResponse =
          await _fileService.uploadFile(audioFile, MediaType.audio);
      await _databaseRepository.updateMessage(
        savedMsg.copyWith(
          mediaUrl: uploadResponse.mediaUrl,
          isUploadingMedia: false,
          mediaId: uploadResponse.mediaId,
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
        isUploadingMedia: false,
        failedToUploadMedia: true,
      ));
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
    await _databaseRepository.insertMessage(message);
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
      _logger.e("Error uploading image file ::: $e");
      await _databaseRepository.updateMessage(savedMsg.copyWith(
        isUploadingMedia: false,
        failedToUploadMedia: true,
      ));
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
    final id = _authService.user!.id;
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
    final MessageModel message = MessageModel.onReceivedFromMap(data);
    await _databaseRepository.insertMessage(message);
    await emitMessageDelivered(message.serverId!);

    if (message.messageType != MessageType.text) {
      final savedMessage =
          await _databaseRepository.getMessageById(message.id!);
      if (savedMessage == null) {
        _logger.e("Saved Message not found: ");
        return;
      }
      savedMessage.copyWith(isDownloadingMedia: true);
      final localMediaPath = await _fileService.downloadFile(
          message.mediaUrl!, message.messageType);
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
  Future<void> emitMessageDelivered(String serverId) async {
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
  Future<void> emitMessageRead(String serverId) async {
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
    final id = data['server_id'];
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
    final messages = await _databaseRepository.getMessagesWithUserByStatus(
      sender: _authService.user!.id,
      receiver: receiverId,
      status: MessageStatus.delivered,
    );
    if (messages.isNotEmpty) {
      final ids = messages.map((e) => e.serverId!).toList();
      _socket.emit(
        _messageBulkRead,
        {
          "server_ids": ids,
          "sender_id": messages[0].sender,
        },
      );
    }
    return;
  }

  @override
  Future<void> onBulkRead(Map<String, dynamic> json) async {
    final data = json['data'];
    _logger.d("On Bulk Read Data ::: $data");
    final ids = data['message_ids'] as List<String>;
    if (ids.isNotEmpty) {
      await _databaseRepository.updateMessagesStatusByServerId(
        ids,
        MessageStatus.read,
      );
    }
    return;
  }

  // ********************** DELETE MESSAGE ****************************************************

  @override
  Future<void> emitDeleteMessage(String serverId) async {
    final message = await _databaseRepository.getMessageByServerId(serverId);
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

  @override
  Future<void> receiveMessagesOnSocketConnect(Map<String, dynamic> json) async {
    final data = json['data'] as List;
    //
    final messages = data.map((e) => MessageModel.fromMap(e)).toList();
    for (var i = 0; i < messages.length; i++) {
      final message = messages[i];
      if (message.messageType == MessageType.text) {
        await _databaseRepository.insertMessage(message);
        final savedMessage =
            await _databaseRepository.getMessageById(message.id!);
        if (savedMessage != null) {
          emitMessageDelivered(savedMessage.serverId!);
        }
        _logger.e("Message with ID: ${message.id} not found");
      }
      // TODO: Handle Downloading of messages
    }
  }

  @override
  StreamController<ContactModel?> get currentChat => _currentChat;

  @override
  Future<void> reDownloadMedia(MessageModel message) async {
    // TODO: implement reDownloadMedia
    throw UnimplementedError();
  }

  @override
  Future<void> reUploadMedia(MessageModel message) async {
    final File file = File(message.localMediaPath!);

    try {
      await _databaseRepository.updateMessage(
        message.copyWith(failedToUploadMedia: false, isUploadingMedia: true),
      );
      final response = await _fileService.uploadFile(file, message.mediaType!);
      _socket.emit(
        _messageEvent,
        () => {
          ...message.mapToServerDB(),
          'media_id': response.mediaId,
          'media_url': response.mediaUrl,
        },
      );
      await _databaseRepository.updateMessage(
        message.copyWith(failedToUploadMedia: null, isUploadingMedia: false),
      );
    } catch (e) {
      _logger.e("Error Re-Uploading File: $e");
      await _databaseRepository.updateMessage(
        message.copyWith(failedToUploadMedia: true, isUploadingMedia: false),
      );
    }
  }

  @override
  Stream<List<MessageModel>> searchChat(String query, String receiver) async* {
    final sender = _authService.user!.id;
    yield* _databaseRepository.searchChat(
      query,
      sender: sender,
      receiver: receiver,
    );
  }
}
