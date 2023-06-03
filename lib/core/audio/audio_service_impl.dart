import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:harmony_chat_demo/core/audio/audio_service_interface.dart';

class AudioServiceImpl implements IAudioService {
  final _fluuterSound = FlutterSound();
  @override
  // TODO: implement isPlaying
  bool get isPlaying => throw UnimplementedError();

  @override
  bool get isRecording => _fluuterSound.isRecording;

  @override
  Future<void> pauseAudio(String path) {
    // TODO: implement pauseAudio
    throw UnimplementedError();
  }

  @override
  Future<void> playAudio(String path) {
    // TODO: implement playAudio
    throw UnimplementedError();
  }

  @override
  Future<void> startRecord() async {
    await _fluuterSound.startRecorder();
  }

  @override
  Future<File?> stopRecord() async {
    final path = await _fluuterSound.stopRecorder();
    return File(path);
  }
}
