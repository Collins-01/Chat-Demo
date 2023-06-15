import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/core/locator.dart';
import 'package:harmony_chat_demo/core/models/contact_model.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/models/message_type.dart';
import 'package:harmony_chat_demo/core/remote/auth/auth_service_interface.dart';
import 'package:harmony_chat_demo/views/chat/components/components.dart';
import 'package:harmony_chat_demo/views/chat/viewmodels/message_section_viewmodel.dart';
import 'package:harmony_chat_demo/views/widgets/app_text.dart';

final IAuthService _authService = locator();

// ignore: must_be_immutable
class MessagesSection extends ConsumerWidget {
  ScrollController? controller;
  final ContactModel contactModel;
  MessagesSection(this.contactModel, this.controller, {Key? key})
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
            child: SingleChildScrollView(
              controller: controller,
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
                            return AudioBubble(
                              message: message,
                              isSender: isSender,
                              isPlaying: model.isPlaying,
                              onPlayPauseButtonClick:
                                  model.onPlayPauseButtonClick(),
                            );

                          case MessageType.text:
                            return TextBubble(
                                message: message, isSender: isSender);

                          case MessageType.image:
                            return ImageBubble(
                                message: message, isSender: isSender);

                          default:
                            return TextBubble(
                                message: message, isSender: isSender);
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
