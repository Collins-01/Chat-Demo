import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/navigations/navigations.dart';

import '../../../core/network_service/exceptions/exceptions.dart';
import '../../../utils/utils.dart';
import '../../view_states/view_states.dart';
import '../../widgets/widgets.dart';

IAuthService _authService = locator();

class RegisterViewModel extends BaseViewModel {
  final _logger = appLogger(RegisterViewModel);
  register(String email, String password) async {
    try {
      changeState(const ViewModelState.busy());
      await _authService.register(email, password);
      changeState(const ViewModelState.idle());
      NavigationService.instance.navigateToReplace(
        NavigationRoutes.EMAIL_VERIFICATION,
        arguments: email,
      );
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

final registerViewModel = ChangeNotifierProvider<RegisterViewModel>((ref) {
  return RegisterViewModel();
});
