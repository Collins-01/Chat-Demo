import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/services/file_picker/file_picker_service_interface.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/media_type.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/message_type.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:harmony_chat_demo/utils/utils.dart';
import 'package:uuid/uuid.dart';
import '../../../services/audio/audio.dart';

final IChatService _chatService = locator();
final IFilePickerService _filePickerService = locator();
final IAudioService _audioService = locator();
final IAuthService _authService = locator();
// final IFileService _fileService = locator();

class InputSectionViewModel extends ChangeNotifier {
  final _logger = appLogger(InputSectionViewModel);
  final Ref ref;
  InputSectionViewModel(this.ref);
  final uuid = const Uuid();
  final myId = _authService.user!.id;
  File? _selectedFile;
  File? get selectedFile => _selectedFile;
  File? _audioFile;

  recordAudio() async {
    await _audioService.startRecord();
  }

  stopRecord(ContactModel contact) async {
    _audioFile = await _audioService.stopRecord();
    if (_audioFile != null) {
      _logger.i("Path to audio file:  ${_audioFile!.path}");
      MessageModel message = MessageModel(
        id: uuid.v1(),
        content: '',
        localId: uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sender: myId,
        receiver: contact.serverId,
        mediaType: MediaType.audio,
        localMediaPath: _audioFile!.path,
        messageType: MessageType.audio,
      );
      await _chatService.sendMessage(message, contact, _audioFile);
    }
    _logger.i("No Audio file path found");
  }

  ValueNotifier<bool> get isRecording => _audioService.isRecordingAudio;
  pickImage(ContactModel contact) async {
    var response = await _filePickerService.pickImage(true);
    if (response != null) {
      // final localMedaiPath =
      //     await _fileService.saveFile(response, MediaType.image);
      MessageModel message = MessageModel(
        id: uuid.v1(),
        content: '',
        localId: uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sender: myId,
        receiver: contact.serverId,
        mediaType: MediaType.image,
        localMediaPath: response.path,
        messageType: MessageType.image,
      );
      await _chatService.sendMessage(message, contact, response);
    }
    _logger.d("No Image selected ");
  }

  sendMessage(ContactModel contact, String content) async {
    if (content.isNotEmpty) {
      MessageModel message = MessageModel(
        id: uuid.v1(),
        content: content,
        localId: uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        messageType: MessageType.text,
        sender: myId,
        receiver: contact.serverId,
      );
      await _chatService.sendMessage(message, contact, null);
    }
    _logger.i("Can't send message with empty content ");
  }
}

final inputSectionViewModel =
    ChangeNotifierProvider<InputSectionViewModel>((ref) {
  return InputSectionViewModel(ref);
});
