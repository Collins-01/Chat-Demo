import 'dart:io';

import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/services/audio/audio_service_interface.dart';
import 'package:harmony_chat_demo/services/permissions/permission_interface.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

class AudioServiceImpl implements IAudioService {
  // final _flutterSound = FlutterSound();
  late final IPermissionService _permissionService;

  AudioServiceImpl({IPermissionService? permissionService})
      : _permissionService = permissionService ?? locator();

  final BehaviorSubject<bool> _isRecordingStream =
      BehaviorSubject.seeded(false);
  Future<String> get _recordingOutputPath async {
    final dir = await getApplicationDocumentsDirectory();
    final timeInMillisecs = DateTime.now().millisecondsSinceEpoch;
    return "${dir.path}/media/VN_$timeInMillisecs.mp3";
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
    var isPermitted = await _permissionService.requestMicrophonePermission();
    if (isPermitted) {
      var path = await _recordingOutputPath;
      _isRecordingStream.add(true);
      // await _flutterSound.startRecorder(uri: path);
    }
    return;
  }

  @override
  Future<File?> stopRecord() async {
    // final path = await _flutterSound.stopRecorder();
    _isRecordingStream.add(false);
    return null;
    // return File(path);
  }

  @override
  Stream<bool> get isRecordingStream => _isRecordingStream.asBroadcastStream();
}
