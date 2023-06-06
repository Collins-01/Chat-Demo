import 'dart:io';

abstract class IFileService {
  Future<String?> uploadFile(File file, String mediaType);
}
