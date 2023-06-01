import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/views/chat/components/components.dart';
import 'package:harmony_chat_demo/views/chat/components/input_section.dart';

class ChatView extends StatelessWidget {
  final ContactModel contactModel;
  const ChatView({super.key, required this.contactModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${contactModel.lastName} ${contactModel.firstName}"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MessagesSection(contactModel),
            InputSection(contactModel),
          ],
        ),
      ),
    );
  }
}
