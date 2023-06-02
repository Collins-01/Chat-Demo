import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/navigations/navigation_routes.dart';
import 'package:harmony_chat_demo/views/auth/confirm_otp_view.dart';
import 'package:harmony_chat_demo/views/splash_screen_view.dart';
import 'package:harmony_chat_demo/views/views.dart';

class RouteGenerators {
  static Route<dynamic> generateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case NavigationRoutes.LOGIN:
        return MaterialPageRoute(
          builder: (_) => const LoginView(),
        );
      case NavigationRoutes.SIGNUP:
        return MaterialPageRoute(
          builder: (_) => const ResgisterView(),
        );

      case NavigationRoutes.EMAIL_VERIFICATION:
        final email = routeSettings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ConfirmOtpView(email: email),
        );

      case NavigationRoutes.HOME:
        return MaterialPageRoute(
          builder: (_) => const HomeView(),
        );
      case NavigationRoutes.SPLASH_SCREEN:
        return MaterialPageRoute(
          builder: (_) => const SplashScreenView(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("No route defined for ${routeSettings.name}"),
            ),
          ),
        );
    }
  }
}
