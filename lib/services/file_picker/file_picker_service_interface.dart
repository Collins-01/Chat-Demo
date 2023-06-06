import 'dart:io';

abstract class IFilePickerService {
  Future<File?> pickImage([bool isGallery = false]);
  Future<File?> pickVideo([bool isGallery = false]);
}
