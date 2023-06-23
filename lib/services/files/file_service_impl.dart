import 'dart:convert';

import 'package:harmony_chat_demo/core/models/file_upload_model.dart';
import 'package:harmony_chat_demo/core/network_service/network_client.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:harmony_chat_demo/services/files/file_service_interface.dart';
import 'package:harmony_chat_demo/utils/utils.dart';
import "package:http/http.dart" as http;

import '../../core/models/models.dart';

class FileServiceImpl implements IFileService {
  final NetworkClient _client = NetworkClient.instance;
  final _logger = appLogger(FileServiceImpl);

  _checkPathForMedia(String type) async {
    final dir = await getApplicationDocumentsDirectory();

    switch (type) {
      case MediaType.audio:
        () async {
          _logger.d("Checking if path exists for audio");
          final fileDirectory = "${dir.path}/${MediaConstants.AUDIO_PATH}/";
          if (!await Directory(fileDirectory).exists()) {
            _logger.d("Path does not exist for audio, creating...");
            await Directory(fileDirectory).create(recursive: true);
          } else {
            _logger.d("Path already exists for audio.");
            return;
          }
        };
        break;
      case MediaType.image:
        () async {
          _logger.d("Checking if path exists for image");
          final fileDirectory = "${dir.path}/${MediaConstants.IMAGE_PATH}/";
          if (!await Directory(fileDirectory).exists()) {
            _logger.d("Path does not exist for image, creating...");
            await Directory(fileDirectory).create(recursive: true);
          } else {
            _logger.d("Path already exists for image.");
            return;
          }
        };
        break;
      default:
    }
  }

  Future<String> _getDirectoryForFileType(String type) async {
    final dir = await getApplicationDocumentsDirectory();

    switch (type) {
      case MediaType.audio:
        return "${dir.path}${MediaConstants.AUDIO_PATH}";

      case MediaType.image:
        return "${dir.path}${MediaConstants.IMAGE_PATH}";
      default:
        return '';
    }
  }

  @override
  Future<FileUploadModel> uploadFile(File file, String mediaType) async {
    _logger.d("Uploading file from path::: ${file.path}");
    try {
      // var result = await _uploadFileWithHttp(file, mediaType);
      var result = await _client.uploadFile(
        uri: '/messaging/upload-file',
        body: {'type': mediaType},
        file: {
          'file': file,
        },
      );
      _logger.d("Response from uploading file::: $result");
      final data = result['data'] as Map<String, dynamic>;
      final url = data['url'] as String;
      final id = data['id'] as String;
      return FileUploadModel(
        mediaId: id,
        mediaUrl: url,
        mediaType: mediaType,
      );
    } catch (e) {
      _logger.e("Error Uploading file:: $e");
      rethrow;
    }
  }

  @override
  Future<String?> downloadFile(String url, String type) async {
    try {
      await _checkPathForMedia(type);
      // final filePath = await _getDirectoryForFileType(type);
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/";
      _logger.d("File path forfile to be downloaded ==== $filePath");
      final fileExtension = url.split(".").last;
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      File newFile = File('$filePath$fileName.$fileExtension');
      _logger.d("path to new file::: ${newFile.path}");
      final response = await http.get(
        Uri.parse(url),
      );

      var raf = newFile.openSync(mode: FileMode.write);
      raf.writeFromSync(response.bodyBytes);
      await raf.close();
      _logger.d(
          'File downloaded and saved successfully.:::: Path ${newFile.path}');
      return newFile.path;
    } catch (e) {
      _logger.e("Error Downloading file :: $e");
      rethrow;
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

  @override
  Future<String> saveFile(File file, String type) async {
    _logger.d("Old File path ::: ${file.path}");
    await _checkPathForMedia(type);
    final pathForNewFile = await _getDirectoryForFileType(type);
    final fileName = p.basenameWithoutExtension(file.path);
    final fileExtension = file.path.split(".").last;
    File newFile = await file.copy("$pathForNewFile$fileName.$fileExtension");
    _logger.d("Newly copied path:: ${newFile.path}");
    return newFile.path;
  }

  _uploadFileWithHttp(File file, String mediaType) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
            "${NetworkClient.baseUrl}/messaging/upload-file",
          ));

      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['type'] = mediaType;
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      final data = json.decode(responseBody) as Map<String, dynamic>;
      return data;
    } catch (e) {
      _logger.e("Error Uploading File:::------:::::: $e");
      rethrow;
    }
  }
}
