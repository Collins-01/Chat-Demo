// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:harmony_chat_demo/core/enums/message_status.dart';
import 'package:harmony_chat_demo/core/enums/message_type.dart';

MessageStatus messageStatusToEnum(String value) {
  if (value == 'sent') {
    return MessageStatus.sent;
  }
  if (value == 'delivered') {
    return MessageStatus.delivered;
  }
  if (value == 'read') {
    return MessageStatus.read;
  }
  return MessageStatus.failed;
}

class MessageModel {
  String? id;
  String? content;
  String localId;
  int? remoteId;
  DateTime createdAt;
  DateTime updatedAt;
  MessageStatus? status;
  String sender;
  String receiver;
  MessageType? type;
  MessageModel({
    this.id = "",
    this.content = "",
    required this.localId,
    this.remoteId = 0,
    required this.createdAt,
    required this.updatedAt,
    this.status = MessageStatus.failed,
    required this.sender,
    required this.receiver,
    this.type = MessageType.text,
  });

  MessageModel copyWith({
    String? id,
    String? content,
    String? localId,
    int? remoteId,
    DateTime? createdAt,
    DateTime? updatedAt,
    MessageStatus? status,
    String? sender,
    String? receiver,
    MessageType? type,
  }) {
    return MessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'localId': localId,
      'remoteId': remoteId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'status': status,
      'sender': sender,
      'receiver': receiver,
      'type': type.toString()
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      content: map['content'] as String,
      localId: map['localId'] as String,
      remoteId: map['remoteId'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      status: messageStatusToEnum(map['status']),
      sender: map['sender'] as String,
      receiver: map['receiver'] as String,
      type: MessageType.text,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory MessageModel.fromDB(Map<String, dynamic> source) =>
      MessageModel.fromMap(source);

  Map<String, dynamic> mapToDB() => {};
}
