// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum MessageStatus { sent, delivered, read, unsent }

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
  return MessageStatus.unsent;
}

class MessageModel {
  int id;
  String content;
  String localId;
  int remoteId;
  DateTime createdAt;
  DateTime updatedAt;
  MessageStatus status;
  String sender;
  String receiver;
  MessageModel({
    required this.id,
    required this.content,
    required this.localId,
    required this.remoteId,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.sender,
    required this.receiver,
  });

  MessageModel copyWith({
    int? id,
    String? content,
    String? localId,
    int? remoteId,
    DateTime? createdAt,
    DateTime? updatedAt,
    MessageStatus? status,
    String? sender,
    String? receiver,
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
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as int,
      content: map['content'] as String,
      localId: map['localId'] as String,
      remoteId: map['remoteId'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      status: messageStatusToEnum(map['status']),
      sender: map['sender'] as String,
      receiver: map['receiver'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toDBMap() => {};
}
