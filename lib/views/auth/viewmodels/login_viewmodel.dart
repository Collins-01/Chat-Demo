import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/network_service/exceptions/failure.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/views/view_states/base_viewmodel.dart';
import 'package:harmony_chat_demo/views/view_states/view_model_state.dart';
import 'package:harmony_chat_demo/views/widgets/app_flushbar.dart';

IAuthService _authService = locator();

class LoginViewModel extends BaseViewModel {
  login(String email, String password) async {
    try {
      changeState(const ViewModelState.busy());
      await _authService.login(email, password);
      changeState(const ViewModelState.idle());
    } on Failure catch (e) {
      changeState(ViewModelState.error(e));
      AppFlushBar.showError(title: e.title, message: e.message);
    } catch (e) {
      // changeState(const ViewModelState.error());
      AppFlushBar.showError(title: 'Unexpected Error', message: e.toString());
    }
  }
}

final loginViewModel = ChangeNotifierProvider<LoginViewModel>((ref) {
  return LoginViewModel();
});
