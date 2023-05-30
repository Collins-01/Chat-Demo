import 'dart:io';
import 'package:harmony_chat_demo/core/file/file_service_interface.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';

class FileServiceImpl implements IFileService {
  // final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<File?> pickImage([bool isGallery = true]) async {
    return null;

    // var data = await _imagePicker.getImage(
    //     source: isGallery ? ImageSource.gallery : ImageSource.camera);
    // File file = File(data.path);
    // return file;
  }

  @override
  Future<File?> pickVideo([bool isGallery = true]) async {
    return null;

    // var data = await _imagePicker.getVideo(
    //   source: isGallery ? ImageSource.gallery : ImageSource.camera,
    // );
    // File file = File(data.path);
    // return file;
  }

  @override
  Future<File?> recordAudio(String path) async {
    bool hasPermission = await Record.hasPermission();
    if (hasPermission) {
      await Record.start(
        path: path, encoder: AudioEncoder.AAC_LD, // by default
        bitRate: 128000, // by default
        samplingRate: 44100,
      );
    }

    return null;
  }

  @override
  Future<bool> get isRecording => Record.isRecording();

  @override
  Future<File?> stopAudioRecord(String path) async {
    await Record.stop();
    File file = File(path);
    return file;
  }
}
