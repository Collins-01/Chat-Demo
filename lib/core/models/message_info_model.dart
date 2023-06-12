// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:harmony_chat_demo/core/models/message_type.dart';

import '../local/constants/constants.dart';

class MessageInfoModel {
  final String messageId; //✅
  final String contactId; //✅
  final String? message; //✅
  final String contactServerId; //✅
  final DateTime timestamp;
  final String status; //✅
  final String? messageType;
  final String sender; //✅
  final String receiver; //✅
  final String firstName; //✅
  final String lastName; //✅
  final String avatar; //✅

  MessageInfoModel({
    this.message,
    required this.contactServerId,
    required this.timestamp,
    required this.status,
    this.messageType = MessageType.text,
    required this.sender,
    required this.receiver,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.contactId,
    required this.messageId,
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
    String? contactServerId,
  }) {
    return MessageInfoModel(
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      messageType: messageType ?? this.messageType,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      contactId: contactId ?? this.contactId,
      messageId: messageId ?? this.messageId,
      contactServerId: contactServerId ?? this.contactServerId,
    );
  }

  factory MessageInfoModel.fromDB(Map<String, dynamic> map) {
    return MessageInfoModel(
      contactId: map[ContactField.id], //✅
      messageId: map[MessageField.id], //✅
      message: map[MessageField.content] != null
          ? map[MessageField.content] as String
          : null,
      timestamp: DateTime.parse(map[MessageField.createdAt]).toLocal(),
      status: map['status'] as String,
      messageType: map[MessageField.mediaType],
      sender: map[MessageField.sender] as String,
      receiver: map[MessageField.receiver] as String,
      firstName: map[ContactField.firstName] as String, //✅
      lastName: map[ContactField.lastName] as String, //✅
      avatar: map[ContactField.avatar] as String, //✅
      contactServerId: map[ContactField.serverId], //✅
    );
  }
}
