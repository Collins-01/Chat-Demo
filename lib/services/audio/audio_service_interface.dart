import 'dart:io';

import 'package:flutter/material.dart';

abstract class IAudioService {
  Future<void> startRecord();
  Future<File?> stopRecord();
  // bool get isRecording;

  Future<void> playAudio(String url);
  Future<void> pauseAudio();

  // bool get isPlaying;

  ValueNotifier<bool> get isRecordingAudio;
  ValueNotifier<String> get currentAudioId;

  bool get isPlayingAudio;

  // * Streams
  Stream<Duration> get position;
  Stream<bool> get isPlayingStream;
  Stream<Duration?> get durationStream;
  Duration? get duration;

  setAudioId(String id);
}
