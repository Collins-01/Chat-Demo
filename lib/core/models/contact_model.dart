// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../local/constants/constants.dart';

class ContactModel extends Equatable {
  final String id;
  final String lastName;
  final String firstName;
  final String avatarUrl;
  final String serverId;
  final DateTime createdAt;
  final String occupation;
  final String bio;
  const ContactModel({
    this.id = '',
    required this.lastName,
    this.serverId = '',
    required this.firstName,
    required this.avatarUrl,
    required this.createdAt,
    required this.occupation,
    required this.bio,
  });

  ContactModel copyWith({
    String? id,
    String? lastName,
    String? firstName,
    String? avatarUrl,
    String? serverId,
    DateTime? createdAt,
    String? bio,
    String? occupation,
  }) {
    return ContactModel(
      id: id ?? this.id,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      serverId: serverId ?? this.serverId,
      createdAt: createdAt ?? this.createdAt,
      bio: bio ?? this.bio,
      occupation: occupation ?? this.occupation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'lastName': lastName,
      'firstName': firstName,
      'avatarUrl': avatarUrl,
      'serverId': serverId,
      'createdAt': createdAt,
      'bio': bio,
      'occupation': occupation,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'] as String,
      lastName: map['lastName'] as String,
      firstName: map['firstName'] as String,
      avatarUrl: map['avatarUrl'] as String,
      serverId: map['serverId'] as String,
      createdAt: map['createdAt'] as DateTime,
      bio: map['bio'] as String,
      occupation: map['occupation'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ContactModel.fromDB(Map<String, dynamic> source) => ContactModel(
        id: source[ContactField.id],
        lastName: source[ContactField.lastName],
        firstName: source[ContactField.firstName],
        avatarUrl: source[ContactField.avatar],
        serverId: source[ContactField.serverId],
        createdAt: DateTime.parse(source[ContactField.createdAt]).toLocal(),
        bio: source[ContactField.bio],
        occupation: source[ContactField.occupation],
      );

  Map<String, dynamic> mapToDB() {
    return {
      ContactField.id: id,
      ContactField.lastName: lastName,
      ContactField.firstName: firstName,
      ContactField.avatar: avatarUrl,
      ContactField.serverId: serverId,
      ContactField.createdAt: createdAt.toIso8601String(),
      ContactField.bio: bio,
      ContactField.occupation: occupation,
    };
  }

  @override
  List<Object?> get props => [
        id,
        lastName,
        firstName,
        avatarUrl,
        serverId,
        createdAt,
        occupation,
        bio
      ];
}
