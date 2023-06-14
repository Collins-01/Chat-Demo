import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/message_status.dart';
import 'package:harmony_chat_demo/core/models/message_type.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/views/chat/viewmodels/message_section_viewmodel.dart';
import 'package:harmony_chat_demo/views/widgets/app_text.dart';

final IAuthService _authService = locator();

// ignore: must_be_immutable
class MessagesSection extends ConsumerWidget {
  final ContactModel contactModel;
  MessagesSection(this.contactModel, {Key? key}) : super(key: key);

  bool isLoading = false;
  final userId = _authService.user!.id;

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
                        bool isSender = message.sender == _authService.user!.id;
                        if (message.isDeleted) {
                          return AppText.body("This message is deleted");
                        }
                        switch (message.messageType) {
                          case MessageType.audio:
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BubbleNormalAudio(
                                  isSender: isSender,
                                  color: const Color(0xFFE8E8EE),
                                  duration:
                                      model.duration?.inSeconds.toDouble(),
                                  position: model.position,
                                  isPlaying: model.isPlaying,
                                  isLoading: true,
                                  isPause: !model.isPlaying,
                                  onSeekChanged: (value) {},
                                  onPlayPauseButtonClick: () =>
                                      model.onPlayPauseButtonClick(),
                                  sent: !isSender
                                      ? false
                                      : message.status == MessageStatus.sent,
                                  delivered: !isSender
                                      ? false
                                      : message.status ==
                                          MessageStatus.delivered,
                                  seen: !isSender
                                      ? false
                                      : message.status == MessageStatus.read,
                                  tail: true,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                message.isDownloadingMedia != null
                                    ? AppText.caption(
                                        (message.isDownloadingMedia!)
                                            ? 'Downloading...'
                                            : "")
                                    : const SizedBox.shrink(),
                                message.isUploadingMedia != null
                                    ? AppText.caption(
                                        (message.isUploadingMedia!)
                                            ? 'Uploading...'
                                            : "")
                                    : const SizedBox.shrink(),
                              ],
                            );

                          case MessageType.text:
                            return BubbleNormal(
                              seen: !isSender
                                  ? false
                                  : message.status == MessageStatus.read,
                              delivered: !isSender
                                  ? false
                                  : message.status == MessageStatus.delivered,
                              text: snapshot.data![index].content!,
                              isSender: isSender,
                              color: const Color(0xFFE8E8EE),
                              tail: true,
                              sent: !isSender
                                  ? false
                                  : message.status == MessageStatus.sent,
                            );

                          case MessageType.image:
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BubbleNormalImage(
                                  id: message.id!,
                                  isSender: isSender,
                                  seen: !isSender
                                      ? false
                                      : message.status == MessageStatus.read,
                                  sent: !isSender
                                      ? false
                                      : message.status == MessageStatus.sent,
                                  image: Image.file(
                                    File(message.localMediaPath!),
                                  ),
                                  color: Colors.purpleAccent,
                                  tail: true,
                                  delivered: !isSender
                                      ? false
                                      : message.status ==
                                          MessageStatus.delivered,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                message.isDownloadingMedia != null
                                    ? AppText.caption(
                                        (message.isDownloadingMedia!)
                                            ? 'Downloading...'
                                            : "")
                                    : const SizedBox.shrink(),
                                message.isUploadingMedia != null
                                    ? AppText.caption(
                                        (message.isUploadingMedia!)
                                            ? 'Uploading...'
                                            : "",
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            );

                          default:
                            return BubbleNormal(
                              seen: !isSender
                                  ? false
                                  : message.status == MessageStatus.read,
                              delivered: !isSender
                                  ? false
                                  : message.status == MessageStatus.delivered,
                              text: message.content!,
                              isSender: isSender,
                              color: const Color(0xFFE8E8EE),
                              tail: true,
                              sent: !isSender
                                  ? false
                                  : message.status == MessageStatus.sent,
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
