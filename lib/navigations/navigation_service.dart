import 'package:flutter/material.dart';

class NavigationService {
  NavigationService._();
  static final NavigationService _instance = NavigationService._();
  static NavigationService get instance => _instance;
  final _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  goBack() {
    Navigator.of(navigatorKey.currentState!.context).pop();
  }
  //TODO:
  //Navigate to Different Pages with different types of animations

  Future<void> navigateTo(String route, {Object? arguments}) async {
    await _navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }

  Future<void> navigateToReplace(String route, {Object? arguments}) async {
    await _navigatorKey.currentState
        ?.pushReplacementNamed(route, arguments: arguments);
  }
}
