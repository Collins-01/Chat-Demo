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
  final String? serverId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final String sender;
  final String receiver;
  final String messageType;
  final String? mediaType;
  final String? localMediaPath;
  final String? mediaUrl;
  final bool isDeleted;
  final String? mediaId;
  // * Downloading Media
  final bool? isDownloadingMedia;
  final bool? failedToDownloadMedia;
  // * Uploading Media
  final bool? isUploadingMedia;
  final bool? failedToUploadMedia;

  const MessageModel({
    this.id = "",
    this.mediaId,
    this.content = "",
    required this.localId,
    this.serverId,
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
    this.isDeleted = false,
    this.failedToDownloadMedia,
    this.isUploadingMedia,
  });

  MessageModel copyWith({
    String? id,
    String? content,
    String? localId,
    String? serverId,
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
    bool? isDeleted,
    String? mediaId,
    bool? failedToDownloadMedia,
    bool? isUploadingMedia,
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
      isDeleted: isDeleted ?? this.isDeleted,
      mediaId: mediaId ?? this.mediaId,
      failedToDownloadMedia:
          failedToDownloadMedia ?? this.failedToDownloadMedia,
      isUploadingMedia: isUploadingMedia ?? this.isUploadingMedia,
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
      'mediaId': mediaId,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      createdAt: DateTime
          .now(), //TODO: Will convert to  Dart's defined DateTime later . [created_at]
      localId: data['local_id'], //✅
      receiver: data['receiver'], //✅
      sender: data['sender'], //✅
      id: const Uuid().v4(),
      updatedAt: DateTime
          .now(), //TODO: Will convert to Dart's defined DateTime.  later. [updated_at]
      content: data['content'], //✅
      status: data['status'], //✅
      messageType: data['message_type'], //✅
      serverId: data['server_id'], //✅
      mediaUrl: data['media_url'], //✅
      mediaId: data['media_id'],
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
      mediaId: source[MessageField.mediaId],
      isDeleted: (source[MessageField.isDeleted] == 0 ? false : true),
      isDownloadingMedia: source[MessageField.isDownloadingMedia] == null
          ? null
          : (source[MessageField.isDownloadingMedia] == 0 ? false : true),
      failedToUploadMedia: source[MessageField.failedToUploadMedia] == null
          ? null
          : (source[MessageField.failedToUploadMedia] == 0 ? false : true),
      failedToDownloadMedia: source[MessageField.failedToDownloadMedia] == null
          ? null
          : (source[MessageField.failedToDownloadMedia] == 0 ? false : true),
      isUploadingMedia: source[MessageField.isUploadingMedia] == null
          ? null
          : (source[MessageField.isUploadingMedia] == 0 ? false : true));

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
        MessageField.isDeleted: (isDeleted ? 1 : 0),
        MessageField.mediaId: mediaId,
        // * Downloading Media
        MessageField.isDownloadingMedia:
            (isDownloadingMedia == null) ? null : (isDownloadingMedia! ? 1 : 0),
        MessageField.failedToDownloadMedia: (failedToDownloadMedia == null)
            ? null
            : (failedToDownloadMedia! ? 1 : 0),
        // * Uploading media.
        MessageField.isUploadingMedia:
            (isUploadingMedia == null) ? null : (isUploadingMedia! ? 1 : 0),
        MessageField.failedToUploadMedia: (failedToUploadMedia == null)
            ? null
            : (failedToUploadMedia! ? 1 : 0),
      };

  Map<String, dynamic> mapToServerDB() {
    return {
      'receiver_id': receiver,
      'content': content,
      'local_id': localId,
      'message_type': messageType,
      // 'media_url': mediaUrl,
      // 'media_id': mediaId,
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
        isDeleted,
        mediaId,
        failedToDownloadMedia,
        isUploadingMedia,
      ];
}
