import 'dart:io';

import 'package:harmony_chat_demo/core/models/file_upload_model.dart';

abstract class IFileService {
  Future<FileUploadModel> uploadFile(File file, String mediaType);

  Future<String?> downloadFile(String url, String type);

  Future<String> copyFileToApplicationDirectory(File file);

  Future<String> saveFile(File file, String type);
}
