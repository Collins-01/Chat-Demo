import 'dart:io';
import 'package:harmony_chat_demo/services/file_picker/file_picker_service_interface.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:image_picker/image_picker.dart';

class FilePickerServiceImpl implements IFilePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<File?> pickImage([bool isGallery = true]) async {
    // return null;

    var data = await _imagePicker.getImage(
        source: isGallery ? ImageSource.gallery : ImageSource.camera);
    if (data == null) {
      return null;
    }
    File file = File(data.path);
    return file;
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
}
