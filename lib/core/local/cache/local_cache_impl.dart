import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harmony_chat_demo/core/local/cache/local_cache.dart';
import 'package:harmony_chat_demo/utils/app_logger.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:shared_preferences/shared_preferences.dart';

class LocalCacheImpl implements LocalCache {
  static const _tokenKey = 'userToken';
  static const _userDataKey = 'userData';
  late final _log = appLogger(LocalCacheImpl);
  final _localStorage = const FlutterSecureStorage();

  // late SharedPreferences _sharedPreferences;

  // LocalCacheImpl({
  //   required SharedPreferences sharedPreferences,
  // }) {
  //   _sharedPreferences = sharedPreferences;
  // }

  @override
  Future<void> deleteToken() async {
    try {
      await removeFromLocalCache(_tokenKey);
    } catch (e) {
      _log.i(e);
    }
  }

  @override
  Object? getFromLocalCache(String key) async {
    try {
      final data = await _localStorage.read(key: key);
      _log.i(data);
      if (data != null) {
        return jsonDecode(data);
      }
      return null;
    } catch (e) {
      _log.i(e);
      return null;
    }
    // return null;
  }

  @override
  Future<String?> getToken() async {
    final token = await _localStorage.read(key: _tokenKey);
    _log.i(
      "Token from getToken()  :: $token",
    );
    return token;

    // return await getFromLocalCache(_tokenKey) as String?;
  }

  @override
  Future<void> removeFromLocalCache(String key) async {
    await _localStorage.delete(key: key);
  }

  @override
  Future<void> saveToken(String token) async {
    saveToLocalCache(key: _tokenKey, value: token);
  }

  @override
  Future<void> saveToLocalCache({required String key, required value}) async {
    _log.i('Data being saved: key: $key, value: $value');

    await _localStorage.write(key: key, value: jsonEncode(value));

    // if (value is String) {
    //   await _sharedPreferences.setString(key, value);
    // }
    // if (value is bool) {
    //   await _sharedPreferences.setBool(key, value);
    // }
    // if (value is int) {
    //   await _sharedPreferences.setInt(key, value);
    // }
    // if (value is double) {
    //   await _sharedPreferences.setDouble(key, value);
    // }
    // if (value is List<String>) {
    //   await _sharedPreferences.setStringList(key, value);
    // }
    // if (value is Map) {
    //   await _sharedPreferences.setString(key, json.encode(value));
    // }
  }

  @override
  Future<void> clearCache() async {
    // await _sharedPreferences.clear();
  }

  @override
  Map<String, dynamic>? getUserData() {
    try {
      final data = getFromLocalCache(_userDataKey) as String;
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUserData(Map<String, dynamic> json) async {
    await saveToLocalCache(
      key: _userDataKey,
      value: json,
    );
  }
}
