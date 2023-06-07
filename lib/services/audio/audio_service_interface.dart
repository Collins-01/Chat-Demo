import 'dart:io';

abstract class IAudioService {
  Future<void> startRecord();
  Future<File?> stopRecord();
  bool get isRecording;

  Future<void> playAudio();
  Future<void> pauseAudio();

  bool get isPlaying;

  Stream<bool> get isRecordingStream;

  Stream<bool> get isPlayingAudioStream;
  Stream<Duration> get position;
  Duration? get duration;
}
