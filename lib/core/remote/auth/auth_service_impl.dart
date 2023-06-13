import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/core/local/cache/local.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/network_service/network_client.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:harmony_chat_demo/core/remote/contacts/contact_service_interface.dart';
import 'package:harmony_chat_demo/utils/utils.dart';

import '../../models/models.dart';

class AuthServiceImpl implements IAuthService {
  final _logger = appLogger(AuthServiceImpl);
  late final LocalCache _localCache;
  late final IContactService _contactService;
  // late final IChatService _chatService;
  final String path = '/authentication/';
  final NetworkClient _networkClient = NetworkClient.instance;
  UserModel? _currentUser;
  String? _accessToken;
  String? _refreshToken;

  AuthServiceImpl({
    LocalCache? localCache,
    IContactService? contactService,
    IChatService? chatService,
  })  : _localCache = localCache ?? locator(),
        _contactService = contactService ?? locator();
  // _chatService = chatService ?? locator();

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

    // _logger.d(
    //   "Response from Login ${response.toString()}",
    //   functionName: 'login',
    // );
    var token = response['data']['access_token'];
    var refreshToken = response['data']['refresh_token'];
    var user = response['data']['current_user'];
    _logger.d(user);
    var connections = response['data']['connections'] as List;
    _accessToken = token;
    _refreshToken = refreshToken;
    _currentUser = UserModel.fromMap(user);

    if (_currentUser!.isBioCreated) {
      _logger.w("User created Bio");
      await _localCache.saveToken(token);
      await _localCache.saveUserData(_currentUser!.toMap());

      // final contacts = connections
      //     .map(
      //       (e) => ContactModel(
      //         avatarUrl: e['avatar']['url'],
      //         firstName: e['firstName'],
      //         lastName: e['lastName'],
      //         occupation: '',
      //         id: const Uuid().v4(),
      //         serverId: e['id'],
      //       ),
      //     )
      //     .toList();
      // await _contactService.insertAllContacts(contacts);
    }
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

  @override
  Future<void> onInit(
      {VoidCallback? successCallback, VoidCallback? errorCallback}) async {
    var token = await _localCache.getToken();
    var user = _localCache.getUserData();
    if (user != null && token != null) {
      _accessToken = token;
      _currentUser = UserModel.fromMap(user);
      successCallback?.call();
    } else {
      errorCallback?.call();
    }
  }

  @override
  Future<void> updateUserInfo(Map<String, dynamic> json) async {
    _currentUser = UserModel.fromMap(json);
    await _localCache.saveUserData(_currentUser!.toMap());
  }
}
