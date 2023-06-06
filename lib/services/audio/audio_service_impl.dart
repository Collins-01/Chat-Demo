import 'dart:io';

import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/services/audio/audio_service_interface.dart';
import 'package:harmony_chat_demo/services/permissions/permission_interface.dart';
import 'package:harmony_chat_demo/utils/utils.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:rxdart/subjects.dart';

class AudioServiceImpl implements IAudioService {
  final _logger = appLogger(AudioServiceImpl);
  // final _flutterSound = FlutterSound();
  String _currentPath = '';
  final _audioRecorder = Record();
  late final IPermissionService _permissionService;

  AudioServiceImpl({IPermissionService? permissionService})
      : _permissionService = permissionService ?? locator();

  final BehaviorSubject<bool> _isRecordingStream =
      BehaviorSubject.seeded(false);
  Future<String> get _recordingOutputPath async {
    final dir = await getApplicationDocumentsDirectory();
    final timeInMillisecs = DateTime.now().millisecondsSinceEpoch;

    final path = "${dir.path}/media/VN_$timeInMillisecs.m4a";
    _logger.i('Path to Audio file:: $path');
    return path;
  }

  @override
  // TODO: implement isPlaying
  bool get isPlaying => throw UnimplementedError();

  @override
  bool get isRecording => false;
  // _flutterSound.isRecording;

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
    var isPermitted = await Record.hasPermission();
    if (isPermitted) {
      var path = await _recordingOutputPath;
      _currentPath = path;
      _isRecordingStream.add(true);
      // await Record.start(path: path);
    }
    return;
  }

  @override
  Future<File?> stopRecord() async {
    // await Record.stop();
    _isRecordingStream.add(false);
    return null;

    // return File(_currentPath);
  }

  @override
  Stream<bool> get isRecordingStream => _isRecordingStream.asBroadcastStream();
}
