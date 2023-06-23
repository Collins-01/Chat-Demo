import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/file_upload_model.dart';
import 'package:harmony_chat_demo/services/files/file_service_interface.dart';

class FileBackgroundServiceHandler {
  final IFileService _fileService;
  FileBackgroundServiceHandler({IFileService? fileService})
      : _fileService = fileService ?? locator();
  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;

  void _fileDownloadTask(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) async {
      final String url = message['url'];
      final String type = message['type'];

      // Perform your file download/upload logic here
      // ...
      final path = await _fileService.downloadFile(url, type);

      sendPort.send(path);
    });
  }

  void _fileUploadTask(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen((message) async {
      final File file = message['file'];
      final String type = message['type'];

      // Perform your file download/upload logic here
      // ...
      final response = await _fileService.uploadFile(file, type);

      sendPort.send(response);
    });
  }

  Future<String?> startDownloadBackgroundTask(String url, String type) async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_fileDownloadTask, _receivePort!.sendPort);
    _sendPort = await _receivePort!.first;
    final completer = Completer<String?>();
    _receivePort!.listen((message) {
      if (message != null) {
        completer.complete(message);
        dispose();
      } else {
        completer.completeError(message);
        dispose();
      }
    });

    _sendPort!.send({'url': url, 'type': type});
    return completer.future;
  }

  Future<FileUploadModel> startUploadBackgroundTask(
      File file, String type) async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_fileUploadTask, _receivePort!.sendPort);
    _sendPort = await _receivePort!.first;
    final completer = Completer<FileUploadModel>();
    _receivePort!.listen((message) {
      if (message is FileUploadModel) {
        completer.complete(message);
        dispose();
      } else {
        completer.completeError(message);
        dispose();
      }
    });
    _sendPort!.send({'file': file, 'type': type});
    return completer.future;
  }

  void dispose() {
    _receivePort?.close();
    _isolate?.kill(priority: Isolate.immediate);
  }
}
