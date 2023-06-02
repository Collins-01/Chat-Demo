// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:harmony_chat_demo/core/models/message_type.dart';

import '../local/constants/constants.dart';

class MessageInfoModel {
  final String? message;
  final DateTime timestamp;
  final String status;
  final String? messageType;
  final String? mediaType;
  final String sender;
  final String receiver;
  final String firstName;
  final String lastName;
  final String avatar;
  MessageInfoModel({
    this.message,
    required this.timestamp,
    required this.status,
    this.messageType = MessageType.text,
    this.mediaType,
    required this.sender,
    required this.receiver,
    required this.firstName,
    required this.lastName,
    required this.avatar,
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
  }) {
    return MessageInfoModel(
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      messageType: messageType ?? this.messageType,
      mediaType: mediaType ?? this.mediaType,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'status': status,
      'messageType': messageType,
      'mediaType': mediaType,
      'sender': sender,
      'receiver': receiver,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
    };
  }

  factory MessageInfoModel.fromDB(Map<String, dynamic> map) {
    return MessageInfoModel(
      message: map[MessageField.content] != null
          ? map[MessageField.content] as String
          : null,
      timestamp: DateTime.parse(map[MessageField.createdAt]).toLocal(),
      status: map['status'] as String,
      messageType: map[MessageField.mediaType],
      mediaType: map[MessageField.mediaType] != null
          ? map[MessageField.mediaType] as String
          : null,
      sender: map[MessageField.sender] as String,
      receiver: map[MessageField.receiver] as String,
      firstName: map[ContactField.firstName] as String,
      lastName: map[ContactField.lastName] as String,
      avatar: map[ContactField.avatar] as String,
    );
  }

  @override
  bool operator ==(covariant MessageInfoModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.timestamp == timestamp &&
        other.status == status &&
        other.messageType == messageType &&
        other.mediaType == mediaType &&
        other.sender == sender &&
        other.receiver == receiver &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.avatar == avatar;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        timestamp.hashCode ^
        status.hashCode ^
        messageType.hashCode ^
        mediaType.hashCode ^
        sender.hashCode ^
        receiver.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        avatar.hashCode;
  }
}
