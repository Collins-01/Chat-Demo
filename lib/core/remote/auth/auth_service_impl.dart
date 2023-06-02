import 'package:harmony_chat_demo/core/models/user_model.dart';
import 'package:harmony_chat_demo/core/network_service/network_client.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';

class AuthServiceImpl implements IAuthService {
  final NetworkClient _networkClient = NetworkClient.instance;
  final UserModel _currentUser = UserModel(
    avatar:
        'https://images.unsplash.com/photo-1531891437562-4301cf35b7e4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1064&q=80',
    email: 'oriakhicolls01@gmail.com',
    firstName: 'Collins',
    lastName: 'Oriakhi',
    id: '001',
  );
  @override

  /// When a user logs in, a list of the user's connections(contacts) will be returned alongside with the user's
  /// credentials, for local storage.
  ///
  Future<void> login(String username, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  UserModel? get user => _currentUser;

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> register(String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<void> verifyOtp(String email, String code) {
    // TODO: implement verifyOtp
    throw UnimplementedError();
  }

  @override
  // TODO: implement accessToken
  String? get accessToken => throw UnimplementedError();

  @override
  // TODO: implement refreshToken
  String? get refreshToken => throw UnimplementedError();
}
