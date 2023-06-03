import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/file/file_service_interface.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/remote/user/dto/dto.dart';
import 'package:harmony_chat_demo/core/remote/user/user_service_interface.dart';
import 'package:harmony_chat_demo/views/widgets/widgets.dart';

import '../../../core/network_service/exceptions/exceptions.dart';
import '../../view_states/view_states.dart';

IFileService _fileService = locator();
IUserService _userService = locator();

class CreateBioViewModel extends BaseViewModel {
  File? _selectedImage;
  File? get selectedImage => _selectedImage;
  pickImage() async {
    var file = await _fileService.pickImage(true);
    _selectedImage = file;
    notifyListeners();
  }

  Future createBio(String firstName, String lastName, String gender,
      String occupation) async {
    try {
      changeState(const ViewModelState.busy());
      await _userService.createBio(
        CreateBioDto(
          image: _selectedImage!,
          firstName: firstName,
          lastName: lastName,
          occupation: occupation,
          gender: gender,
        ),
      );
      changeState(const ViewModelState.idle());
    } on Failure catch (e) {
      changeState(ViewModelState.error(e));
      AppFlushBar.showError(title: e.title, message: e.message);
    } catch (e) {
      changeState(
        const ViewModelState.idle(),
      );
      AppFlushBar.showError(title: 'Error', message: e.toString());
    }
  }
}

final createBioViewModel = ChangeNotifierProvider<CreateBioViewModel>((ref) {
  return CreateBioViewModel();
});
