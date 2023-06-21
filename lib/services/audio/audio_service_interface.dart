import 'dart:io';

import 'package:flutter/material.dart';

abstract class IAudioService {
  Future<void> startRecord();
  Future<File?> stopRecord();
  // bool get isRecording;

  Future<void> playAudio();
  Future<void> pauseAudio();

  // bool get isPlaying;

  ValueNotifier<bool> get isRecordingAudio;

  bool get isPlayingAudio;
  Stream<Duration> get position;
  Duration? get duration;
}
