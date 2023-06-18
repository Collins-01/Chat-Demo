import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';
import 'package:harmony_chat_demo/views/view_states/base_viewmodel.dart';

import '../../../core/models/models.dart';

IChatService _chatService = locator();

class ChatViewViewModel extends BaseViewModel {
  onModelReady(ContactModel contact) async {
    await Future.delayed(const Duration(seconds: 2));
    // _chatService.emitBulkRead(contact.serverId);
    _chatService.currentChat.add(contact);
  }

  onModelDisposed() {
    _chatService.currentChat.add(null);
  }
}

final chatViewViewModel = ChangeNotifierProvider<ChatViewViewModel>((ref) {
  return ChatViewViewModel();
});
