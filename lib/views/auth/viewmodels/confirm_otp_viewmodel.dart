import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/views/widgets/widgets.dart';

import '../../../core/network_service/exceptions/failure.dart';
import '../../view_states/view_states.dart';

IAuthService _authService = locator();

class ConfirmOtpViewModel extends BaseViewModel {
  verifyOtp(String code, String email) async {
    try {
      changeState(const ViewModelState.busy());
      await _authService.verifyOtp(email, code);
      changeState(const ViewModelState.idle());
    } on Failure catch (e) {
      changeState(ViewModelState.error(e));
      AppFlushBar.showError(title: e.title, message: e.message);
    } catch (e) {
      changeState(const ViewModelState.idle());
      // changeState(const ViewModelState.error());
      AppFlushBar.showError(title: 'Error', message: e.toString());
    }
  }
}

final confirmOtpViewModel = ChangeNotifierProvider<ConfirmOtpViewModel>((ref) {
  return ConfirmOtpViewModel();
});
