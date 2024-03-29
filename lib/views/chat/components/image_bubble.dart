// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/views/chat/components/receiver_image_bubble.dart';
import 'package:harmony_chat_demo/views/chat/components/sender_image_bubble.dart';
import 'package:harmony_chat_demo/views/widgets/app_text.dart';

import '../../../core/models/models.dart';

class ImageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isSender;
  final void Function()? reUpload;
  final void Function()? reDownload;
  const ImageBubble({
    Key? key,
    required this.message,
    required this.isSender,
    this.reUpload,
    this.reDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //* This stack is for assumption that the images is being uploaded or failed to be uploaded
        isSender
            ? SenderImageBubble(
                reUpload: reUpload,
                isSender: isSender,
                message: message,
              )
            : ReceiverImageBubble(
                reDownload: reDownload,
                isSender: isSender,
                message: message,
              ),
        AppText.caption("${message.updatedAt.hour}:${message.updatedAt.minute}")
      ],
    );
  }
}
