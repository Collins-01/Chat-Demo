import 'package:harmony_chat_demo/core/local/cache/local.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/user_model.dart';
import 'package:harmony_chat_demo/core/network_service/network_client.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/utils/utils.dart';

class AuthServiceImpl implements IAuthService {
  final _logger = appLogger(AuthServiceImpl);
  late final LocalCache _localCache;
  final String path = '/authentication/';
  final NetworkClient _networkClient = NetworkClient.instance;

  String? _accessToken;
  String? _refreshToken;

  AuthServiceImpl({LocalCache? localCache})
      : _localCache = localCache ?? locator();
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
  Future<void> login(String username, String password) async {
    var response = await _networkClient.post(
      '${path}login',
      body: {
        'email': username,
        'password': password,
      },
    );
    var token = response['data']['access_token'];
    var refreshToken = response['data']['refresh_token'];
    var user = response['data']['current_user'];
    var connections = response['data']['connections'];
    var usBioCreated = response['data']['current_user']['isBioCreated'];
    _accessToken = token;
    _refreshToken = refreshToken;
    await _localCache.saveToken(token);
    _logger.i("Response from Login ${response.toString()}",
        functionName: 'login');
  }

  @override
  UserModel? get user => _currentUser;

  @override
  Future<void> logout() async {}

  @override
  Future<void> register(String email, String password) async {
    var response = await _networkClient.post(
      '${path}register',
      body: {
        'email': email,
        'password': password,
      },
    );
    _logger.i("Response from Login", error: response, functionName: 'login');
  }

  @override
  Future<void> verifyOtp(String email, String code) async {
    var response = await _networkClient.post(
      '${path}otp/verify',
      body: {
        'email': email,
        'code': code,
      },
    );
    _logger.i(response.toString());
  }

  @override
  String? get accessToken => _accessToken;

  @override
  String? get refreshToken => _refreshToken;
}
