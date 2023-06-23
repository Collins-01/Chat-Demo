// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/views/chat/components/text_bubble.dart';
import 'package:harmony_chat_demo/views/chat/viewmodels/search_chat_viewmodel.dart';

import '../../utils/utils.dart';

class SearchChatView extends ConsumerWidget {
  final String receiver;
  SearchChatView({
    Key? key,
    required this.receiver,
  }) : super(key: key);
  final TextEditingController searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(searchChatViewModel);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(hintText: 'Search'),
              onChanged: (value) {
                _debouncer.run(() {
                  // * Call Method
                  model.searchChat(value, receiver);
                });
              },
            ),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                initialData: const [],
                stream: model.messages,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Snapshot Error :: ${snapshot.error}");
                  }
                  if (!snapshot.hasData) {
                    return const Text("Snapshot has no data");
                  }
                  if (snapshot.data == null) {
                    return const Text("Snapshot data is null");
                  }
                  if (snapshot.data!.isEmpty) {
                    return const Text("Snapshot data is empty");
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      MessageModel message = snapshot.data![index];
                      return TextBubble(
                          message: message, isSender: message.isMe);
                    },
                    itemCount: snapshot.data!.length,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
