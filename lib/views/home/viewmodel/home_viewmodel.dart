import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:harmony_chat_demo/utils/app_logger.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/models/models.dart';

IChatService _chatService = locator();

class HomeViewModel extends ChangeNotifier {
  final _logger = const AppLogger(HomeViewModel);
  // final Ref ref;
  HomeViewModel() {
    _chatService.getContactsAsStream('chat').listen((event) {
      _contactStream.add(event);
    }, onError: (e) {
      _logger.e("Error Receiving contacts as stream :: ", error: e);
    });
  }

  final BehaviorSubject<List<ContactModel>> _contactStream =
      BehaviorSubject<List<ContactModel>>();
  Stream<List<ContactModel>> get contactStream => _contactStream;
  Stream<List<ContactModel>> contactStreamPattern(String pattern) =>
      _chatService.getContactsAsStream(pattern);
}

final homeViewModel = ChangeNotifierProvider<HomeViewModel>((ref) {
  return HomeViewModel();
});
