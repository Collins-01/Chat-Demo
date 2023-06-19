import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';

import '../../view_states/view_states.dart';

IChatService _chatService = locator();

class SearchChatViewModel extends BaseViewModel {
  Stream<List<MessageModel>> _messages = const Stream.empty();
  Stream<List<MessageModel>> get messages => _messages;

  void searchChat(String query, String receiver) {
    _messages = const Stream.empty();
    final data = _chatService.searchChat(query, receiver);
    _messages = data;
    notifyListeners();
  }
}

final searchChatViewModel = ChangeNotifierProvider<SearchChatViewModel>((ref) {
  return SearchChatViewModel();
});
