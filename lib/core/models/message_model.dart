// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:harmony_chat_demo/core/local/constants/message_field.dart';

import '../enums/enums.dart';

class MessageModel {
  String? id;
  String? content;
  String localId;
  int? serverId;
  DateTime createdAt;
  DateTime updatedAt;
  MessageStatus? status;
  String sender;
  String receiver;
  MessageType? messageType;
  MediaType? mediaType;
  String? localMediaPath;
  String? mediaUrl;
  MessageModel({
    this.id = "",
    this.content = "",
    required this.localId,
    this.serverId = 0,
    required this.createdAt,
    required this.updatedAt,
    this.status = MessageStatus.failed,
    required this.sender,
    required this.receiver,
    this.messageType = MessageType.text,
    this.mediaType,
    this.localMediaPath,
    this.mediaUrl,
  });

  MessageModel copyWith({
    String? id,
    String? content,
    String? localId,
    int? serverId,
    DateTime? createdAt,
    DateTime? updatedAt,
    MessageStatus? status,
    String? sender,
    String? receiver,
    MessageType? messageType,
    MediaType? mediaType,
    String? localMediaPath,
    String? mediaUrl,
  }) {
    return MessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      messageType: messageType ?? this.messageType,
      mediaType: mediaType ?? this.mediaType,
      localMediaPath: localMediaPath ?? this.localMediaPath,
      mediaUrl: mediaUrl ?? this.mediaUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'localId': localId,
      'serverId': serverId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'status': status,
      'sender': sender,
      'receiver': receiver,
      'messageType': messageType,
      'mediaType': mediaType,
      'mediaUrl': mediaUrl,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      content: map['content'] as String,
      localId: map['localId'] as String,
      serverId: map['serverId'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      status: MessageStatus.values.firstWhere(
        (element) => element.toString().split('.').last == map['status'],
      ),
      sender: map['sender'] as String,
      receiver: map['receiver'] as String,
      messageType: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
      ),
      mediaType: MediaType.values.firstWhere(
        (element) => element.toString().split('.').last == map['mediaType'],
      ),
      mediaUrl: map['mediaUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory MessageModel.fromDB(Map<String, dynamic> source) =>
      MessageModel.fromMap(source);

  Map<String, dynamic> mapToDB() => {
        MessageField.id: id,
        MessageField.content: content,
        MessageField.localId: localId,
        MessageField.severId: serverId,
        MessageField.createdAt: createdAt,
        MessageField.updatedAt: updatedAt,
        MessageField.status: status,
        MessageField.mediaType: mediaType,
        MessageField.messageType: messageType,
        MessageField.sender: sender,
        MessageField.receiver: receiver,
        MessageField.localMediaPath: localMediaPath,
        MessageField.mediaUrl: mediaUrl,
      };
}
