// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/views/chat/components/input_section.dart';
import 'package:harmony_chat_demo/views/chat/viewmodels/chat_view_viewmodel.dart';

import 'components/components.dart';

class ChatView extends ConsumerStatefulWidget {
  final ContactModel contactModel;
  const ChatView({
    super.key,
    required this.contactModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  @override
  void initState() {
    ref.read(chatViewViewModel.notifier).onModelReady(widget.contactModel);
    super.initState();
  }

  @override
  void dispose() {
    ref.read(chatViewViewModel.notifier).onModelDisposed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.contactModel.lastName} ${widget.contactModel.firstName}"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MessagesSection(widget.contactModel),
            InputSection(widget.contactModel),
          ],
        ),
      ),
    );
  }
}
