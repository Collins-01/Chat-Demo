import 'dart:io';

abstract class IAudioService {
  Future<void> startRecord();
  Future<File?> stopRecord();
  bool get isRecording;

  Future<void> playAudio(String path);
  Future<void> pauseAudio(String path);

  bool get isPlaying;

  Stream<bool> get isRecordingStream;
}
