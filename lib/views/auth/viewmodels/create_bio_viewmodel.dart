import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/file/file_service_interface.dart';
import 'package:harmony_chat_demo/core/locator.dart';

import '../../view_states/view_states.dart';

IFileService _fileService = locator();

class CreateBioViewModel extends BaseViewModel {
  File? _selectedImage;
  File? get selectedImage => _selectedImage;
  pickImage() async {
    var file = await _fileService.pickImage(true);
    _selectedImage = file;
    notifyListeners();
  }
}

final createBioViewModel = ChangeNotifierProvider<CreateBioViewModel>((ref) {
  return CreateBioViewModel();
});
