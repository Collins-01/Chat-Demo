import 'package:dio/dio.dart';
import 'package:harmony_chat_demo/core/models/file_upload_model.dart';
import 'package:harmony_chat_demo/core/network_service/network_client.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:harmony_chat_demo/services/files/file_service_interface.dart';
import 'package:harmony_chat_demo/utils/utils.dart';

class FileServiceImpl implements IFileService {
  final NetworkClient _client = NetworkClient.instance;
  final _logger = appLogger(FileServiceImpl);
  @override
  Future<FileUploadModel> uploadFile(File file, String mediaType) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      var result = await _client.uploadFile(
        uri: '/messaging/upload-file',
        body: {'type': mediaType},
        file: {
          'file': file,
        },
      );
      _logger.d("Response from uploading file::: $result");
      final data = result['data'];
      return FileUploadModel.fromMap(
        data,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> downloadFile(String url) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final fileExtension = url.split(".").last;
      final filePath = '$dir/media/$fileName.$fileExtension';
      final r = await NetworkClient.dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      File file = File(filePath);
      await file.writeAsBytes(r.data);
      print('File downloaded and saved successfully.');
      return file.path;
    } catch (e) {
      _logger.e("Error Downloading file :: $e");
      return null;
    }
  }

  @override
  Future<String> copyFileToApplicationDirectory(File file) async {
    final dir = await getApplicationDocumentsDirectory();
    _logger.d("Application Directory::: $dir");
    final fileExtension = p.extension(file.path);
    _logger.d("File extension::: $fileExtension");
    final fileName = p.basenameWithoutExtension(file.path);
    _logger.d("File name::: $fileName");
    File newFile = await file.copy("$dir/media/$fileName$fileExtension");
    return newFile.path;
  }
}
