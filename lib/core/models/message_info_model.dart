// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/message_type.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';

import '../local/constants/constants.dart';

extension XMessageInfoModel on MessageInfoModel {
  bool get isMe {
    IAuthService authService = locator();
    return authService.user?.id == sender;
  }
}

class MessageInfoModel {
  final String messageId; //✅
  final String contactId; //✅
  final String message; //✅
  final String messageServerId; //✅
  final DateTime timestamp;
  final String status; //✅
  final String messageType;
  final String sender; //✅
  // final String receiver; //✅
  final String firstName; //✅
  final String lastName; //✅
  final String avatar; //✅
  final int unreadMessages;

  MessageInfoModel({
    this.message = '',
    required this.messageServerId,
    required this.timestamp,
    required this.status,
    this.messageType = MessageType.text,
    required this.sender,
    // required this.receiver,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.contactId,
    required this.messageId,
    this.unreadMessages = 0,
  });

  MessageInfoModel copyWith({
    String? message,
    DateTime? timestamp,
    String? status,
    String? messageType,
    String? mediaType,
    String? sender,
    String? receiver,
    String? firstName,
    String? lastName,
    String? avatar,
    String? messageId,
    String? contactId,
    String? messageServerId,
    int? unreadMessages,
  }) {
    return MessageInfoModel(
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      messageType: messageType ?? this.messageType,
      // receiver: receiver ?? this.receiver,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      contactId: contactId ?? this.contactId,
      messageId: messageId ?? this.messageId,
      messageServerId: messageServerId ?? this.messageServerId,
      unreadMessages: unreadMessages ?? this.unreadMessages,
      sender: sender ?? this.sender,
    );
  }

  factory MessageInfoModel.fromDB(Map<String, dynamic> map) {
    return MessageInfoModel(
      contactId: map[ContactField.id], //✅
      messageId: map[MessageField.id], //✅
      message: map[MessageField.content],
      timestamp: DateTime.parse(map[MessageField.updatedAt]),
      status: map[MessageField.status],
      messageType: map[MessageField.messageType],
      sender: map[MessageField.sender],
      // receiver: map[MessageField.receiver],
      firstName: map[ContactField.firstName], //✅
      lastName: map[ContactField.lastName], //✅
      avatar: map[ContactField.avatar], //✅
      messageServerId: map[MessageField.serverId], //✅
      unreadMessages: map['unreadMessagesCount'],
    );
  }
}
