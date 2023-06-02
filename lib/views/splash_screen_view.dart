import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/core/local/cache/local.dart';
import 'package:harmony_chat_demo/core/local/db/database_repository.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/views/home/home.dart';

import 'auth/auth.dart';

final DatabaseRepository _databaseRepository = locator();
final LocalCache _localCache = locator();

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  _onInit() async {
    var token = await _localCache.getToken();

    if (token != null) {
      await _databaseRepository.initializeDB();

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const HomeView()));
    } else {
      await _databaseRepository.initializeDB();

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginView()));
    }
  }

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Harmony Chat Demo"),
      ),
    );
  }
}
