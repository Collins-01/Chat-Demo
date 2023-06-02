import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/core/local/db/database_repository.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/views/auth/login_view.dart';

final DatabaseRepository _databaseRepository = locator();

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  _onInit() async {
    await _databaseRepository.initializeDB();

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const LoginVew()));
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
