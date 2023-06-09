// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String? firstName;
  final String? lastName;
  final String email;
  final String id;
  final String? avatar;
  final bool isBioCreated;
  UserModel({
    this.firstName,
    this.lastName,
    required this.email,
    required this.id,
    this.avatar,
    this.isBioCreated = false,
  });

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? id,
    String? avatar,
    bool? isBioCreated,
  }) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      isBioCreated: isBioCreated ?? this.isBioCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'id': id,
      'avatar': avatar,
      'isBioCreated': isBioCreated,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      email: map['email'] as String,
      id: map['id'] as String,
      avatar: map['avatar'] != null ? map['avatar']['url'] as String : null,
      isBioCreated: map['isBioCreated'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(firstName: $firstName, lastName: $lastName, email: $email, id: $id, avatar: $avatar, isBioCreated: $isBioCreated)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.id == id &&
        other.avatar == avatar &&
        other.isBioCreated == isBioCreated;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        id.hashCode ^
        avatar.hashCode ^
        isBioCreated.hashCode;
  }
}
