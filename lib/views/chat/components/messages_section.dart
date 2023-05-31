import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/views/chat/viewmodels/message_section_viewmodel.dart';

class MessagesSection extends ConsumerWidget {
  const MessagesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(messageSectionViewModel);
    return Expanded(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: BubbleNormal(
              delivered: true,
              text: 'bubble normal with tail',
              isSender: true,
              color: const Color(0xFFE8E8EE),
              tail: true,
              sent: true,
            ),
          ),
          DateChip(
            date: DateTime.now(),
          ),
          BubbleNormal(
            text: 'bubble normal with tail',
            isSender: true,
            color: const Color(0xFFE8E8EE),
            tail: true,
            sent: true,
          ),
        ],
      ),
    );
  }
}
