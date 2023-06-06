import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/services/file_picker/file_picker_service_interface.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/media_type.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/message_type.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:uuid/uuid.dart';

import '../../../services/audio/audio.dart';

final IChatService _chatService = locator();
final IFilePickerService _fileService = locator();
final IAudioService _audioService = locator();

class InputSectionViewModel extends ChangeNotifier {
  final Ref ref;
  InputSectionViewModel(this.ref);
  final uuid = const Uuid();
  final myId = '001';
  File? _selectedFile;
  File? get selectedFile => _selectedFile;
  File? _audioFile;

  recordAudio() async {
    await _audioService.startRecord();
  }

  stopRecord() async {
    _audioFile = await _audioService.stopRecord();
  }

  Stream<bool> get isRecording => _audioService.isRecordingStream;
  setSelectedFile() {}

  sendMessage(ContactModel contact, String content) async {
    if (_selectedFile == null && _audioFile == null) {
      MessageModel message = MessageModel(
        id: uuid.v1(),
        content: content,
        localId: uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sender: myId,
        receiver: contact.id,
      );
      await _chatService.sendMessage(message, contact, null);
    }
    if (_audioFile != null && content.isEmpty && _selectedFile == null) {
      MessageModel message = MessageModel(
        id: uuid.v1(),
        content: '',
        localId: uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        sender: myId,
        receiver: contact.id,
        mediaType: MediaType.audio,
        localMediaPath: _audioFile!.path,
        messageType: MessageType.audio,
      );
      await _chatService.sendMessage(message, contact, _audioFile);
    }
  }
}

final inputSectionViewModel =
    ChangeNotifierProvider<InputSectionViewModel>((ref) {
  return InputSectionViewModel(ref);
});
