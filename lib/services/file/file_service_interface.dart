import 'dart:io';

abstract class IFileService {
  Future<File?> pickImage([bool isGallery = false]);

  Future<File?> pickVideo([bool isGallery = false]);

  Future<File?> recordAudio(String path);

  Future<File?> stopAudioRecord(String path);

  Future<bool> get isRecording;
}
