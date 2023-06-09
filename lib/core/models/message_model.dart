// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:harmony_chat_demo/core/local/constants/message_field.dart';
import 'package:harmony_chat_demo/core/models/message_status.dart';
import 'package:harmony_chat_demo/core/models/message_type.dart';
import 'package:uuid/uuid.dart';

class MessageModel extends Equatable {
  final String? id;
  final String? content;
  final String localId;
  final int? serverId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final String sender;
  final String receiver;
  final String messageType;
  final String? mediaType;
  final String? localMediaPath;
  final String? mediaUrl;
  final bool? isDownloadingMedia;
  final bool? failedToUploadMedia;

  const MessageModel({
    this.id = "",
    this.content = "",
    required this.localId,
    this.serverId = 0,
    required this.createdAt,
    required this.updatedAt,
    this.status = MessageStatus.unsent,
    required this.sender,
    required this.receiver,
    this.messageType = MessageType.text,
    this.localMediaPath,
    this.mediaUrl,
    this.mediaType,
    this.isDownloadingMedia = false,
    this.failedToUploadMedia = false,
  });

  MessageModel copyWith({
    String? id,
    String? content,
    String? localId,
    int? serverId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    String? sender,
    String? receiver,
    String? messageType,
    String? mediaType,
    String? localMediaPath,
    String? mediaUrl,
    bool? isDownloadingMedia,
    bool? failedToUploadMedia,
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
      isDownloadingMedia: isDownloadingMedia ?? this.isDownloadingMedia,
      failedToUploadMedia: failedToUploadMedia ?? this.failedToUploadMedia,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'localId': localId,
      'serverId': serverId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
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
      id: const Uuid().v4(),
      content: map['content'] == null ? '' : map['content'] as String,
      localId: map['localId'] as String,
      serverId: map['id'] as int,
      createdAt: map['createdAt'] == null
          ? DateTime.now()
          : DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] == null
          ? DateTime.now()
          : DateTime.parse(map['updatedAt']),
      status: map['status'],
      sender: map['sender']['id'] as String,
      receiver: map['receiver']['id'] as String,
      messageType: map['media'] as String,
      // mediaType: map['mediaType'] as String,
      mediaUrl: map['mediaUrl'] == null ? null : map['mediaUrl']['url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory MessageModel.fromDB(Map<String, dynamic> source) => MessageModel(
        createdAt: DateTime.parse(source[MessageField.createdAt]).toLocal(),
        updatedAt: DateTime.parse(source[MessageField.updatedAt]).toLocal(),
        localId: source[MessageField.localId],
        receiver: source[MessageField.receiver],
        sender: source[MessageField.sender],
        content: source[MessageField.content],
        id: source[MessageField.id],
        localMediaPath: source[MessageField.localMediaPath],
        mediaType: source[MessageField.mediaType],
        mediaUrl: source[MessageField.mediaUrl],
        messageType: source[MessageField.messageType],
        serverId: source[MessageField.serverId],
        status: source[MessageField.status],
        isDownloadingMedia: source[MessageField.isDownloadingMedia] == null
            ? null
            : (source[MessageField.isDownloadingMedia] == 0 ? false : true),
        failedToUploadMedia: source[MessageField.failedToUploadMedia] == null
            ? null
            : (source[MessageField.failedToUploadMedia] == 0 ? false : true),
      );

  Map<String, dynamic> mapToDB() => {
        MessageField.id: id,
        MessageField.content: content,
        MessageField.localId: localId,
        MessageField.serverId: serverId,
        MessageField.createdAt: createdAt.toIso8601String(),
        MessageField.updatedAt: updatedAt.toIso8601String(),
        MessageField.status: status,
        MessageField.mediaType: mediaType,
        MessageField.messageType: messageType,
        MessageField.sender: sender,
        MessageField.receiver: receiver,
        MessageField.localMediaPath: localMediaPath,
        MessageField.mediaUrl: mediaUrl,
        MessageField.isDownloadingMedia:
            (isDownloadingMedia == null) ? null : (isDownloadingMedia! ? 1 : 0),
        MessageField.failedToUploadMedia: (failedToUploadMedia == null)
            ? null
            : (failedToUploadMedia! ? 1 : 0),
      };

  Map<String, dynamic> mapToServerDB() {
    return {
      'receiver_id': receiver,
      'content': content,
      'local_id': localId,
      'media_type': mediaType,
      'message_type': messageType,
    };
  }

  @override
  List<Object?> get props => [
        id,
        content,
        localId,
        serverId,
        createdAt,
        updatedAt,
        status,
        messageType,
        messageType,
        sender,
        receiver,
        localMediaPath,
        mediaUrl,
        isDownloadingMedia,
        failedToUploadMedia,
      ];
}
