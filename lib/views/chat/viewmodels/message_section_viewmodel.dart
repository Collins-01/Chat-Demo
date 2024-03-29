import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/user_model.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:harmony_chat_demo/services/audio/audio.dart';
import 'package:just_audio/just_audio.dart';

IChatService _chatService = locator();
IAuthService _authService = locator();
IAudioService _audioService = locator();

class MessageSectionViewModel extends ChangeNotifier {
  final bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  Duration? get duration => _audioService.duration;
  double _position = 0.0;
  double get position => _position;
  MessageSectionViewModel() {
    _audioService.position.listen((value) {
      _position = value.inSeconds.toDouble();
      notifyListeners();
    });
  }
  Stream<ProcessingState> get processingStateStream =>
      _audioService.playingProcessingState;
  ValueNotifier<String> get currentAudioId => _audioService.currentAudioId;
  Stream<List<MessageModel>> messagesStream(ContactModel contact) =>
      _chatService.watchMessagesWithContact(contact);

  UserModel get user => _authService.user!;

  updateMessageStatus(String status) {
    // _chatService
  }

  Stream<Duration?> get durationStream => _audioService.durationStream;
  Stream<bool> get isPlayingStream => _audioService.isPlayingStream;

  onPlayPauseButtonClick(String url) async {
    if (_isPlaying) {
      await _audioService.pauseAudio();
    } else {
      await _audioService.playAudio(url);
    }
  }

  void deleteMessageForMe(String id) async {
    await _chatService.deleteMessageForMe(id);
  }

  void deleteMessage(String id) async {
    await _chatService.emitDeleteMessage(id);
  }

  reUploadMedia(MessageModel message) async {
    await _chatService.reUploadMedia(message);
  }

  reDownloadMedia(MessageModel message) async {
    await _chatService.reDownloadMedia(message);
  }

  playAudio(String url) async {
    await _audioService.playAudio(url);
  }

  stopAudio() async {
    await _audioService.pauseAudio();
  }

  setCurrentAudioId(String id) {
    _audioService.setAudioId(id);
  }
}

final messageSectionViewModel =
    ChangeNotifierProvider<MessageSectionViewModel>((ref) {
  return MessageSectionViewModel();
});
