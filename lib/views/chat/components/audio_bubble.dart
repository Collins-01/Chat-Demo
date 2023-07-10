// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
import 'package:flutter/material.dart';

import 'package:harmony_chat_demo/core/models/models.dart';
import 'package:just_audio/just_audio.dart';

class AudioBubble extends StatelessWidget {
  final MessageModel message;
  final bool isSender;
  final Duration? duration;
  final double? position;
  final bool isPlaying;
  final void Function() onPlayPauseButtonClick;
  final void Function()? stopAudio;
  final void Function(String id)? playAudio;
  final ProcessingState? processingState;
  final void Function(String id) setCurrentAudioId;
  final void Function(MessageModel message)? reDownloadMedia;
  final void Function(MessageModel message)? reUploadMedia;
  const AudioBubble(
      {Key? key,
      required this.message,
      required this.isSender,
      this.duration,
      this.position,
      this.stopAudio,
      this.playAudio,
      this.processingState,
      this.reUploadMedia,
      this.isPlaying = false,
      this.reDownloadMedia,
      required this.setCurrentAudioId,
      required this.onPlayPauseButtonClick,
      th})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // (message.failedToDownloadMedia != null &&
        //         message.failedToDownloadMedia!)
        !isSender
            ? IconButton(
                onPressed: () {
                  if (message.failedToDownloadMedia != null &&
                      message.failedToDownloadMedia!) {
                    reDownloadMedia?.call(message);
                  }
                  if (message.failedToDownloadMedia != null &&
                      message.failedToDownloadMedia!) {
                    reDownloadMedia?.call(message);
                  }
                },
                icon: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
              )
            : const SizedBox.shrink(),
        Expanded(
          child: BubbleNormalAudio(
            isSender: isSender,
            color: const Color(0xFFE8E8EE),
            duration: duration?.inSeconds.toDouble(),
            position: position,
            isPlaying: isPlaying,
            isLoading: processingState == ProcessingState.loading ||
                (message.isDownloadingMedia != null &&
                    message.isDownloadingMedia!) ||
                (message.isUploadingMedia != null && message.isUploadingMedia!),
            isPause:
                !isPlaying || processingState! == ProcessingState.completed,
            onSeekChanged: (value) {},
            onPlayPauseButtonClick: () {
              setCurrentAudioId(message.localId);

              if (isPlaying) {
                stopAudio?.call();
              } else {
                playAudio?.call(message.localMediaPath!);
              }
            },
            sent: !isSender ? false : message.status == MessageStatus.sent,
            delivered:
                !isSender ? false : message.status == MessageStatus.delivered,
            seen: !isSender ? false : message.status == MessageStatus.read,
            tail: true,
          ),
        ),

        // (message.failedToUploadMedia != null &&
        //         message.failedToUploadMedia!)
        isSender
            ? IconButton(
                onPressed: () {
                  if (message.failedToDownloadMedia != null &&
                      message.failedToDownloadMedia!) {
                    reDownloadMedia?.call(message);
                  }
                  if (message.failedToUploadMedia != null &&
                      message.failedToUploadMedia!) {
                    reUploadMedia?.call(message);
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
}
