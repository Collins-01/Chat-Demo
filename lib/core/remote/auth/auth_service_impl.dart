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
  UserModel? _currentUser;
  String? _accessToken;
  String? _refreshToken;

  AuthServiceImpl({LocalCache? localCache})
      : _localCache = localCache ?? locator();

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
    // var connections = response['data']['connections'];
    _accessToken = token;
    _refreshToken = refreshToken;
    _currentUser = UserModel.fromMap(user);
    await _localCache.saveToken(token);
    await _localCache.saveUserData(_currentUser!.toMap());
    _logger.i(
      "Response from Login ${response.toString()}",
      functionName: 'login',
    );
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
