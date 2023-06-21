import 'dart:io';

import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/services/audio/audio_service_interface.dart';
import 'package:harmony_chat_demo/services/files/file_service_interface.dart';
import 'package:harmony_chat_demo/utils/utils.dart';
import 'package:just_audio/just_audio.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioServiceImpl implements IAudioService {
  final _logger = appLogger(AudioServiceImpl);

  late final IFileService _fileService;

  AudioServiceImpl({IFileService? fileService})
      : _fileService = fileService ?? locator();

  String _currentAudioPath = '';
  final _audioPlayer = AudioPlayer();
  final ValueNotifier<bool> _isRecordingAudio = ValueNotifier(false);

  // _handleDirectoryCheck() async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   final fileDirectory = "$dir${MediaConstants.AUDIO_PATH}";
  //   if (await Directory(fileDirectory).exists()) {
  //     _logger.i("Directory exists: $fileDirectory");
  //     return;
  //   } else {
  //     await Directory(fileDirectory).create(recursive: true);
  //     _logger.d("Directory does not exist, creating audio directory........");
  //   }
  // }

  Future<String> get _recordingOutputPath async {
    // await _handleDirectoryCheck();
    final dir = await getApplicationDocumentsDirectory();
    final timeInMillisecs = DateTime.now().millisecondsSinceEpoch;

    final path = "${dir.path}/Voice_Note_$timeInMillisecs.m4a";
    _logger.d('Path to Audio file:: $path');
    return path;
  }

  Duration? _duration;

  @override
  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> playAudio() async {
    await _audioPlayer.stop();
    var dur = await _audioPlayer.setUrl(_currentAudioPath);
    await _audioPlayer.play();
    if (dur != null) {
      _duration = dur;
    }
    _logger.e("No Duration found for audio with path: $_currentAudioPath");
  }

  @override
  Future<void> startRecord() async {
    var isPermitted = await Record.hasPermission();

    if (isPermitted) {
      var path = await _recordingOutputPath;
      _currentAudioPath = path;
      await Record.start(
        path: path,
      );
      _isRecordingAudio.value = true;
    }
    _logger.e("Record Permission not enabled");
    return;
  }

  @override
  Future<File?> stopRecord() async {
    await Record.stop();
    _isRecordingAudio.value = false;
    return File(_currentAudioPath);
  }

  @override
  ValueNotifier<bool> get isRecordingAudio => _isRecordingAudio;

  @override
  bool get isPlayingAudio => _audioPlayer.playerState.playing;

  @override
  Stream<Duration> get position =>
      _audioPlayer.createPositionStream().asBroadcastStream();

  @override
  Duration? get duration => _duration;
}
