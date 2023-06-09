import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:harmony_chat_demo/utils/app_logger.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core/models/models.dart';

IChatService _chatService = locator();
IAuthService _authService = locator();

class HomeViewModel extends ChangeNotifier {
  final _logger = const AppLogger(HomeViewModel);
  // final Ref ref;
  HomeViewModel() {
    initializeChatService();
    _chatService.getMyLastConversations().listen((event) {
      _messagesStream.add(event);
      _logger.i("New Message :: ${event.toString()}");
    }, onError: (e) {
      _logger.e("Error Receiving contacts as stream :: ", error: e);
    });
  }
  UserModel? user = _authService.user;

  final BehaviorSubject<List<MessageInfoModel>> _messagesStream =
      BehaviorSubject<List<MessageInfoModel>>();

  Stream<List<MessageInfoModel>> get messagesStream => _messagesStream;
}

initializeChatService() async {
  await _chatService.init();
}

final homeViewModel = ChangeNotifierProvider<HomeViewModel>((ref) {
  return HomeViewModel();
});
