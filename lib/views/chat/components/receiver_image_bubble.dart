// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';

import 'package:harmony_chat_demo/views/widgets/app_text.dart';

import '../../../core/models/models.dart';

class ReceiverImageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isSender;
  final void Function()? cancelDownload;
  final void Function()? reDownload;
  const ReceiverImageBubble({
    Key? key,
    required this.message,
    required this.isSender,
    this.cancelDownload,
    this.reDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (message.isDownloadingMedia != null && message.isDownloadingMedia!)
          Container(
            height: 100,
            width: 100,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: AppText.body("Downloading Media..."),
          ),
        if (message.failedToDownloadMedia != null &&
            message.isDownloadingMedia!)
          Container(
            height: 100,
            width: 100,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: AppText.body("Failed To Donwload Media..."),
          ),
        if (message.localMediaPath != null)
          BubbleNormalImage(
            id: message.id!,
            isSender: isSender,
            seen: !isSender ? false : message.status == MessageStatus.read,
            sent: !isSender ? false : message.status == MessageStatus.sent,
            image: message.localMediaPath != null
                ? Image.file(
                    File(message.localMediaPath!),
                  )
                : Column(children: [
                    const Icon(Icons.error_outline),
                    AppText.caption("Image path not found")
                  ]),
            color: Colors.purpleAccent,
            tail: true,
            delivered:
                !isSender ? false : message.status == MessageStatus.delivered,
          ),
        GestureDetector(
          onTap: () {
            // * If it's failed to upload, re-upload else re-download
            if (message.failedToDownloadMedia != null &&
                message.failedToDownloadMedia!) {
              reDownload?.call();
            }
            if (message.isDownloadingMedia != null &&
                message.isDownloadingMedia!) {
              cancelDownload?.call();
            }
          },
          child: Builder(
            builder: (_) {
              if (message.isDownloadingMedia != null &&
                  message.isDownloadingMedia!) {
                return Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(.5),
                  ),
                  child: const CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  ),
                );
              }
              if (message.failedToDownloadMedia != null &&
                  message.failedToDownloadMedia!) {
                return Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(.5),
                  ),
                  child: const Icon(Icons.error_outline),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        )
      ],
    );
  }
}
