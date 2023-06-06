import 'package:harmony_chat_demo/core/network_service/network_client.dart';
import 'dart:io';

import 'package:harmony_chat_demo/services/files/file_service_interface.dart';

class FileServiceImpl implements IFileService {
  final NetworkClient _client = NetworkClient.instance;
  @override
  Future<String?> uploadFile(File file, String mediaType) async {
    try {
      var response = await _client.sendFormData(
        FormDataType.post,
        uri: '/messaging/upload-file',
        body: {
          'type': mediaType,
        },
      );
      final data = response['data'] as Map<String, String>;
      final url = data['url'] as String;
      return url;
    } catch (e) {
      rethrow;
    }
  }
}
