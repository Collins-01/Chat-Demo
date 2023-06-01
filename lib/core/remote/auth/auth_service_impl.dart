import 'package:harmony_chat_demo/core/models/user_model.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';

class AuthServiceImpl implements IAuthService {
  final UserModel _currentUser = UserModel(
    avatar:
        'https://images.unsplash.com/photo-1531891437562-4301cf35b7e4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1064&q=80',
    email: 'oriakhicolls01@gmail.com',
    firstName: 'Collins',
    lastName: 'Oriakhi',
    id: '001',
  );
  @override
  Future<void> login(String username, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  UserModel? get user => _currentUser;
}
