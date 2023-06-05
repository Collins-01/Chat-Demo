import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/file/file_service_interface.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:uuid/uuid.dart';

import '../../../services/audio/audio.dart';

final IChatService _chatService = locator();
final IFileService _fileService = locator();
final IAudioService _audioService = locator();

class InputSectionViewModel extends ChangeNotifier {
  final Ref ref;
  InputSectionViewModel(this.ref);
  final uuid = const Uuid();
  final myId = '001';
  File? _selectedFile;
  File? get selectedFile => _selectedFile;

  recordAudio() async {
    await _audioService.startRecord();
  }

  stopRecord() async {
    await _audioService.stopRecord();
  }

  Stream<bool> get isRecording => _audioService.isRecordingStream;
  setSelectedFile() {}

  sendMessage(ContactModel contact, String content) async {
    MessageModel message = MessageModel(
      id: uuid.v1(),
      content: content,
      localId: uuid.v4(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      sender: myId,
      receiver: contact.id,
    );
    await _chatService.sendMessage(message, contact, _selectedFile);
  }
}

final inputSectionViewModel =
    ChangeNotifierProvider<InputSectionViewModel>((ref) {
  return InputSectionViewModel(ref);
});
