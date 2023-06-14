import 'dart:io';

import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/services/audio/audio_service_interface.dart';
import 'package:harmony_chat_demo/services/permissions/permission_interface.dart';
import 'package:harmony_chat_demo/utils/utils.dart';
import 'package:just_audio/just_audio.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:rxdart/subjects.dart';

class AudioServiceImpl implements IAudioService {
  final _logger = appLogger(AudioServiceImpl);

  late final IPermissionService _permissionService;

  AudioServiceImpl({IPermissionService? permissionService})
      : _permissionService = permissionService ?? locator();

  String _currentAudioPath = '';
  final _audioPlayer = AudioPlayer();
  final BehaviorSubject<bool> _isRecordingStream =
      BehaviorSubject.seeded(false);
  Future<String> get _recordingOutputPath async {
    final dir = await getApplicationDocumentsDirectory();
    final timeInMillisecs = DateTime.now().millisecondsSinceEpoch;

    final path =
        "${dir.path}${MediaConstants.AUDIO_PATH}VN_$timeInMillisecs.m4a";
    _logger.i('Path to Audio file:: $path');
    return path;
  }

  Duration? _duration;
  @override
  bool get isPlaying => throw UnimplementedError();

  @override
  bool get isRecording => false;

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
      _isRecordingStream.add(true);
    }
    return;
  }

  @override
  Future<File?> stopRecord() async {
    await Record.stop();
    _isRecordingStream.add(false);
    return File(_currentAudioPath);
  }

  @override
  Stream<bool> get isRecordingStream => _isRecordingStream.asBroadcastStream();

  @override
  Stream<bool> get isPlayingAudioStream =>
      _audioPlayer.playingStream.asBroadcastStream();

  @override
  Stream<Duration> get position =>
      _audioPlayer.createPositionStream().asBroadcastStream();

  @override
  Duration? get duration => _duration;
}
