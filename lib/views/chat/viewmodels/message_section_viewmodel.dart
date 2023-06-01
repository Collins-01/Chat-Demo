import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/user_model.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/core/remote/chat/chat_interface.dart';

IChatService _chatService = locator();
IAuthService _authService = locator();

class MessageSectionViewModel extends ChangeNotifier {
  Stream<List<MessageModel>> messagesStream(ContactModel contact) =>
      _chatService.watchMessagesWithContact(contact);

  UserModel get user => _authService.user!;

  updateMessageStatus(String status) {
    // _chatService
  }
}

final messageSectionViewModel =
    ChangeNotifierProvider<MessageSectionViewModel>((ref) {
  return MessageSectionViewModel();
});
