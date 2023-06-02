import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import '../../navigations/navigations.dart';

class AppFlushBar {
  static final NavigationService _navigationService =
      NavigationService.instance;
  static void showError(
      {required String title, required String message, int duartion = 4}) {
    Flushbar(
      forwardAnimationCurve: Curves.decelerate,
      reverseAnimationCurve: Curves.easeOut,
      title: title,
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: duartion),
      isDismissible: true,
      backgroundColor: const Color(0xffF30202),
      message: message,
    ).show(_navigationService.navigatorKey.currentState!.context);
  }
}
