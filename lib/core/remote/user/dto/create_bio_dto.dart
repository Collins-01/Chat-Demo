// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

class CreateBioDto {
  final File image;
  final String firstName;
  final String lastName;
  final String occupation;
  final String gender;
  CreateBioDto({
    required this.image,
    required this.firstName,
    required this.lastName,
    required this.occupation,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'occupation': occupation,
      'gender': gender,
    };
  }
}
