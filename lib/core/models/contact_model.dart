// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ContactModel {
  final String id;
  final String lastName;
  final String firstName;
  final String avatarUrl;
  ContactModel({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.avatarUrl,
  });

  ContactModel copyWith({
    String? id,
    String? lastName,
    String? firstName,
    String? avatarUrl,
  }) {
    return ContactModel(
      id: id ?? this.id,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'lastName': lastName,
      'firstName': firstName,
      'avatarUrl': avatarUrl,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'] as String,
      lastName: map['lastName'] as String,
      firstName: map['firstName'] as String,
      avatarUrl: map['avatarUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactModel.fromJson(String source) =>
      ContactModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ContactModel(id: $id, lastName: $lastName, firstName: $firstName, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(covariant ContactModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.lastName == lastName &&
        other.firstName == firstName &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lastName.hashCode ^
        firstName.hashCode ^
        avatarUrl.hashCode;
  }
}
