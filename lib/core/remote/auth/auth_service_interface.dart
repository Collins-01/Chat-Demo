import 'package:harmony_chat_demo/core/models/user_model.dart';

abstract class IAuthService {
  Future<void> login(String username, String password);
  UserModel? get user;
}
