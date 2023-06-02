import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/views/view_states/base_viewmodel.dart';

class RegisterViewModel extends BaseViewModel {}

final registerViewModel = ChangeNotifierProvider<RegisterViewModel>((ref) {
  return RegisterViewModel();
});
