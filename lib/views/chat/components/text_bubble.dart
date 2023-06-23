// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/views/widgets/app_text.dart';

import '../../../core/models/models.dart';

class TextBubble extends StatelessWidget {
  final MessageModel message;
  final bool isSender;
  const TextBubble({Key? key, required this.message, required this.isSender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BubbleNormal(
          seen: !isSender ? false : message.status == MessageStatus.read,
          delivered:
              !isSender ? false : message.status == MessageStatus.delivered,
          text: message.content!,
          isSender: isSender,
          color: const Color(0xFFE8E8EE),
          tail: true,
          sent: !isSender ? false : message.status == MessageStatus.sent,
        ),
        AppText.caption("${message.updatedAt.hour}:${message.updatedAt.minute}")
      ],
    );
  }
}
