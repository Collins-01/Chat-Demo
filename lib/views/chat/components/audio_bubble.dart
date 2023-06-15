// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';

import 'package:harmony_chat_demo/core/models/models.dart';
import 'package:harmony_chat_demo/views/widgets/app_text.dart';

class AudioBubble extends StatelessWidget {
  final MessageModel message;
  final bool isSender;
  final Duration? duration;
  final double? position;
  final bool isPlaying;
  final void Function() onPlayPauseButtonClick;
  const AudioBubble({
    Key? key,
    required this.message,
    required this.isSender,
    this.duration,
    this.position,
    required this.isPlaying,
    required this.onPlayPauseButtonClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BubbleNormalAudio(
          isSender: isSender,
          color: const Color(0xFFE8E8EE),
          duration: duration?.inSeconds.toDouble(),
          position: position,
          isPlaying: isPlaying,
          isLoading: true,
          isPause: !isPlaying,
          onSeekChanged: (value) {},
          onPlayPauseButtonClick: onPlayPauseButtonClick,
          sent: !isSender ? false : message.status == MessageStatus.sent,
          delivered:
              !isSender ? false : message.status == MessageStatus.delivered,
          seen: !isSender ? false : message.status == MessageStatus.read,
          tail: true,
        ),
        AppText.caption("${message.updatedAt.hour}:${message.updatedAt.minute}")
      ],
    );
  }
}
