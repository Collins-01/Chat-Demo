import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/message_status.dart';
import 'package:harmony_chat_demo/views/chat/viewmodels/message_section_viewmodel.dart';

class MessagesSection extends ConsumerWidget {
  final ContactModel contactModel;
  const MessagesSection(this.contactModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(messageSectionViewModel);
    return StreamBuilder<List<MessageModel>>(
        initialData: const [],
        stream: model.messagesStream(contactModel),
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
          return Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(
                    snapshot.data!.length,
                    (index) => GestureDetector(
                      onTap: () {},
                      child: BubbleNormal(
                        seen:
                            snapshot.data![index].status == MessageStatus.read,
                        delivered: snapshot.data![index].status ==
                            MessageStatus.delivered,
                        text: snapshot.data![index].content!,
                        isSender: snapshot.data![index].sender == model.user.id,
                        // isSender: index % 2 == 0,
                        color: const Color(0xFFE8E8EE),
                        tail: true,
                        sent:
                            snapshot.data![index].status == MessageStatus.sent,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
