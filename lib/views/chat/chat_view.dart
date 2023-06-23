// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/views/chat/search_chat_view.dart';
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
  ScrollController? controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatViewViewModel.notifier).onModelReady(widget.contactModel);
      // controller!.animateTo(
      //   controller!.position.maxScrollExtent,
      //   duration: const Duration(milliseconds: 300),
      //   curve: Curves.easeOut,
      // );
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ref.read(chatViewViewModel.notifier).removeUserFromCurrentChat();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        SearchChatView(receiver: widget.contactModel.serverId),
                  ),
                );
              },
              icon: const Icon(Icons.search),
            ),
          ],
          title: Text(
              "${widget.contactModel.lastName} ${widget.contactModel.firstName}"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              MessagesSection(widget.contactModel, controller, _scaffoldKey),
              InputSection(widget.contactModel),
            ],
          ),
        ),
      ),
    );
  }
}
