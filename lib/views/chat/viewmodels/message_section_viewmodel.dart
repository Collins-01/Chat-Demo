import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/user_model.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:harmony_chat_demo/services/audio/audio.dart';

IChatService _chatService = locator();
IAuthService _authService = locator();
IAudioService _audioService = locator();

class MessageSectionViewModel extends ChangeNotifier {
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  Duration? get duration => _audioService.duration;
  double _position = 0.0;
  double get position => _position;
  MessageSectionViewModel() {
    _audioService.isPlayingAudioStream.listen((value) {
      _isPlaying = value;
      notifyListeners();
    });

    _audioService.position.listen((value) {
      _position = value.inSeconds.toDouble();
      notifyListeners();
    });
  }
  Stream<List<MessageModel>> messagesStream(ContactModel contact) =>
      _chatService.watchMessagesWithContact(contact);

  UserModel get user => _authService.user!;

  updateMessageStatus(String status) {
    // _chatService
  }

  onPlayPauseButtonClick() async {
    if (_isPlaying) {
      await _audioService.pauseAudio();
    } else {
      await _audioService.playAudio();
    }
  }

  void deleteMessage(String id) async {
    await _chatService.emitDeleteMessage(id);
  }
}

final messageSectionViewModel =
    ChangeNotifierProvider<MessageSectionViewModel>((ref) {
  return MessageSectionViewModel();
});
