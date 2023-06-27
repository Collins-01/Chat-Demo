import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/message_type.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/views/chat/components/components.dart';
import 'package:harmony_chat_demo/views/chat/viewmodels/message_section_viewmodel.dart';
import 'package:harmony_chat_demo/views/widgets/app_text.dart';
import 'package:just_audio/just_audio.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import '../../../core/models/models.dart';

final IAuthService _authService = locator();

// ignore: must_be_immutable
class MessagesSection extends ConsumerWidget {
  ScrollController? controller;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ContactModel contactModel;
  MessagesSection(this.contactModel, this.controller, this.scaffoldKey,
      {Key? key})
      : super(key: key);

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
            return const Center(child: Text("Snapshot data is empty"));
          }
          return Expanded(
            child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final message = snapshot.data![index];
                  bool isSender = message.sender == _authService.user!.id;
                  if (message.isDeleted) {
                    return AppText.body("This message is deleted");
                  }
                  switch (message.messageType) {
                    case MessageType.audio:
                      return ValueListenableBuilder<String>(
                          valueListenable: model.currentAudioId,
                          builder: (context, currentId, child) {
                            if (currentId == message.localId) {
                              return StreamBuilder3<Duration?, bool,
                                      ProcessingState>(
                                  streams: StreamTuple3(
                                    model.durationStream,
                                    model.isPlayingStream,
                                    model.processingStateStream,
                                  ),
                                  initialData: InitialDataTuple3(
                                    const Duration(seconds: 0),
                                    false,
                                    ProcessingState.idle,
                                  ),
                                  builder: (context, snapshots) {
                                    // return
                                    //     // const Text("Audio");
                                    //     BubbleNormalAudio(
                                    //   isSender: isSender,
                                    //   color: const Color(0xFFE8E8EE),
                                    //   duration: snapshots
                                    //       .snapshot1.data?.inSeconds
                                    //       .toDouble(),
                                    //   position: model.position,
                                    //   isPlaying: snapshots.snapshot2.data!,
                                    //   isLoading: snapshots.snapshot3.data! ==
                                    //           ProcessingState.loading ||
                                    //       (message.isDownloadingMedia != null &&
                                    //           message.isDownloadingMedia!) ||
                                    //       (message.isUploadingMedia != null &&
                                    //           message.isUploadingMedia!),
                                    //   isPause: !snapshots.snapshot2.data! ||
                                    //       snapshots.snapshot3.data! ==
                                    //           ProcessingState.completed,
                                    //   onSeekChanged: (value) {},
                                    //   onPlayPauseButtonClick: () {
                                    //     model
                                    //         .setCurrentAudioId(message.localId);

                                    //     if (snapshots.snapshot2.data!) {
                                    //       model.stopAudio();
                                    //     } else {
                                    //       model.playAudio(
                                    //           message.localMediaPath!);
                                    //     }
                                    //   },
                                    //   sent: !isSender
                                    //       ? false
                                    //       : message.status ==
                                    //           MessageStatus.sent,
                                    //   delivered: !isSender
                                    //       ? false
                                    //       : message.status ==
                                    //           MessageStatus.delivered,
                                    //   seen: !isSender
                                    //       ? false
                                    //       : message.status ==
                                    //           MessageStatus.read,
                                    //   tail: true,
                                    // );
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: BubbleNormalAudio(
                                            isSender: isSender,
                                            color: const Color(0xFFE8E8EE),
                                            duration: snapshots
                                                .snapshot1.data?.inSeconds
                                                .toDouble(),
                                            position: model.position,
                                            isPlaying:
                                                snapshots.snapshot2.data!,
                                            isLoading: snapshots
                                                        .snapshot3.data! ==
                                                    ProcessingState.loading ||
                                                (message.isDownloadingMedia !=
                                                        null &&
                                                    message
                                                        .isDownloadingMedia!) ||
                                                (message.isUploadingMedia !=
                                                        null &&
                                                    message.isUploadingMedia!),
                                            isPause: !snapshots
                                                    .snapshot2.data! ||
                                                snapshots.snapshot3.data! ==
                                                    ProcessingState.completed,
                                            onSeekChanged: (value) {},
                                            onPlayPauseButtonClick: () {
                                              model.setCurrentAudioId(
                                                  message.localId);

                                              if (snapshots.snapshot2.data!) {
                                                model.stopAudio();
                                              } else {
                                                model.playAudio(
                                                    message.localMediaPath!);
                                              }
                                            },
                                            sent: !isSender
                                                ? false
                                                : message.status ==
                                                    MessageStatus.sent,
                                            delivered: !isSender
                                                ? false
                                                : message.status ==
                                                    MessageStatus.delivered,
                                            seen: !isSender
                                                ? false
                                                : message.status ==
                                                    MessageStatus.read,
                                            tail: true,
                                          ),
                                        ),
                                        // (message.failedToDownloadMedia !=
                                        //                 null &&
                                        //             message
                                        //                 .failedToDownloadMedia!) ||
                                        (message.failedToUploadMedia != null &&
                                                message.failedToUploadMedia!)
                                            ? IconButton(
                                                onPressed: () {
                                                  if (message.failedToDownloadMedia !=
                                                          null &&
                                                      message
                                                          .failedToDownloadMedia!) {
                                                    model.reDownloadMedia(
                                                        message);
                                                  }
                                                  if (message.failedToUploadMedia !=
                                                          null &&
                                                      message
                                                          .failedToUploadMedia!) {
                                                    model
                                                        .reUploadMedia(message);
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.error_outline,
                                                  color: Colors.red,
                                                ),
                                              )
                                            : const SizedBox.shrink()
                                      ],
                                    );
                                  });
                            } else {
                              return
                                  // const Text("Audio ");
                                  //     BubbleNormalAudio(
                                  //   isSender: isSender,
                                  //   color: const Color(0xFFE8E8EE),
                                  //   // position: model.position,
                                  //   // isPlaying: model.isPlaying,
                                  //   isLoading: true,
                                  //   // isPause: !model.isPlaying,
                                  //   onSeekChanged: (value) {},
                                  //   onPlayPauseButtonClick: () {
                                  //     model.setCurrentAudioId(message.localId);
                                  //     model.playAudio(message.localMediaPath!);
                                  //   },
                                  //   sent: !isSender
                                  //       ? false
                                  //       : message.status == MessageStatus.sent,
                                  //   delivered: !isSender
                                  //       ? false
                                  //       : message.status == MessageStatus.delivered,
                                  //   seen: !isSender
                                  //       ? false
                                  //       : message.status == MessageStatus.read,
                                  //   tail: true,
                                  // );
                                  Row(
                                children: [
                                  Expanded(
                                    child: BubbleNormalAudio(
                                      isSender: isSender,
                                      color: const Color(0xFFE8E8EE),
                                      // position: model.position,
                                      // isPlaying: model.isPlaying,
                                      isLoading: true,
                                      // isPause: !model.isPlaying,
                                      onSeekChanged: (value) {},
                                      onPlayPauseButtonClick: () {
                                        model
                                            .setCurrentAudioId(message.localId);
                                        model
                                            .playAudio(message.localMediaPath!);
                                      },
                                      sent: !isSender
                                          ? false
                                          : message.status ==
                                              MessageStatus.sent,
                                      delivered: !isSender
                                          ? false
                                          : message.status ==
                                              MessageStatus.delivered,
                                      seen: !isSender
                                          ? false
                                          : message.status ==
                                              MessageStatus.read,
                                      tail: true,
                                    ),
                                  ),
                                  (message.failedToDownloadMedia != null &&
                                              message.failedToDownloadMedia!) ||
                                          (message.failedToUploadMedia !=
                                                  null &&
                                              message.failedToUploadMedia!)
                                      ? IconButton(
                                          onPressed: () {
                                            if (message.failedToDownloadMedia !=
                                                    null &&
                                                message
                                                    .failedToDownloadMedia!) {
                                              model.reDownloadMedia(message);
                                            }
                                            if (message.failedToUploadMedia !=
                                                    null &&
                                                message.failedToUploadMedia!) {
                                              model.reUploadMedia(message);
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ],
                              );
                            }
                          });

                    // AppText.body(message.localMediaPath ?? 'Null');

                    case MessageType.text:
                      return InkWell(
                        onLongPress: () {
                          scaffoldKey.currentState?.showBottomSheet(
                            (context) {
                              return Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 20),
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          model.deleteMessageForMe(message.id!);
                                          Navigator.pop(context);
                                        },
                                        child: AppText.bodyLarge(
                                          "Delete For me",
                                          color: Colors.red,
                                        ),
                                      ),
                                      message.serverId == null
                                          ? const SizedBox.shrink()
                                          : TextButton(
                                              onPressed: () {
                                                if (message.serverId != null &&
                                                    message.sender ==
                                                        model.user.id) {
                                                  model.deleteMessage(
                                                      message.serverId!);
                                                  Navigator.pop(context);
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: AppText.bodyLarge(
                                                "Delete For Everyone",
                                              ),
                                            ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: AppText.bodyLarge(
                                          "Cancel",
                                        ),
                                      ),
                                    ]),
                              );
                            },
                          );
                        },
                        child: TextBubble(message: message, isSender: isSender),
                      );

                    case MessageType.image:
                      return ImageBubble(
                          reDownload: () => model.reDownloadMedia(message),
                          reUpload: () => model.reUploadMedia(message),
                          message: message,
                          isSender: isSender);

                    default:
                      return TextBubble(message: message, isSender: isSender);
                  }
                }),
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
