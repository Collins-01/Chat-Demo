import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/core/local/db/database_repository.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';

import '../navigations/navigations.dart';

final DatabaseRepository _databaseRepository = locator();
IAuthService _authService = locator();

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  _onInit() async {
    await _databaseRepository.initializeDB();
    // NavigationService.instance.navigateToReplace(NavigationRoutes.HOME);
    await _authService.onInit(successCallback: () async {
      // await _databaseRepository.initializeDB();
      if (_authService.user!.isBioCreated) {
        NavigationService.instance.navigateToReplace(NavigationRoutes.HOME);
      } else {
        NavigationService.instance
            .navigateToReplace(NavigationRoutes.CREATE_BIO);
      }
    }, errorCallback: () async {
      // await _databaseRepository.initializeDB();

      NavigationService.instance.navigateToReplace(NavigationRoutes.LOGIN);
    });
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
