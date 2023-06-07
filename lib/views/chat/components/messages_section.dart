import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/message_status.dart';
import 'package:harmony_chat_demo/core/models/message_type.dart';
import 'package:harmony_chat_demo/views/chat/viewmodels/message_section_viewmodel.dart';

// ignore: must_be_immutable
class MessagesSection extends ConsumerWidget {
  final ContactModel contactModel;
  MessagesSection(this.contactModel, {Key? key}) : super(key: key);

  bool isLoading = false;

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
                    (index) => Builder(
                      builder: (context) {
                        final message = snapshot.data![index];

                        switch (message.messageType) {
                          case MessageType.audio:
                            return BubbleNormalAudio(
                              isSender: message.sender == '001',
                              color: const Color(0xFFE8E8EE),
                              duration: model.duration?.inSeconds.toDouble(),
                              position: model.position,
                              isPlaying: model.isPlaying,
                              isLoading: true,
                              isPause: !model.isPlaying,
                              onSeekChanged: (value) {},
                              onPlayPauseButtonClick: () =>
                                  model.onPlayPauseButtonClick(),
                              sent: message.status == MessageStatus.sent,
                            );

                          case MessageType.text:
                            return BubbleNormal(
                              seen: snapshot.data![index].status ==
                                  MessageStatus.read,
                              delivered: snapshot.data![index].status ==
                                  MessageStatus.delivered,
                              text: snapshot.data![index].content!,
                              isSender: snapshot.data![index].sender == '001',
                              color: const Color(0xFFE8E8EE),
                              tail: true,
                              sent: snapshot.data![index].status ==
                                  MessageStatus.sent,
                            );

                          case MessageType.image:
                            return BubbleNormalImage(
                              id: message.id!,
                              isSender: message.sender == '001',
                              seen: message.status == MessageStatus.read,
                              sent: message.status == MessageStatus.sent,
                              image: Image.file(File(message.localMediaPath!)),
                              color: Colors.purpleAccent,
                              tail: true,
                              delivered: true,
                            );

                          default:
                            return BubbleNormal(
                              seen: snapshot.data![index].status ==
                                  MessageStatus.read,
                              delivered: snapshot.data![index].status ==
                                  MessageStatus.delivered,
                              text: snapshot.data![index].content!,
                              isSender: snapshot.data![index].sender == '001',
                              color: const Color(0xFFE8E8EE),
                              tail: true,
                              sent: snapshot.data![index].status ==
                                  MessageStatus.sent,
                            );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

/*
  BubbleNormalImage(
    id: 'id001',
    image: _image(),
    color: Colors.purpleAccent,
    tail: true,
    delivered: true,
  ),
*/
