import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/core/models/user_model.dart';

abstract class IAuthService {
  Future<void> login(String username, String password);
  UserModel? get user;
  Future<void> register(String email, String password);
  Future<void> verifyOtp(String email, String code);
  Future<void> logout();
  Future<void> onInit(
      [VoidCallback? successCallback, VoidCallback? errorCallback]);

  String? get accessToken;
  String? get refreshToken;
}
