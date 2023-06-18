// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/views/widgets/app_text.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/models/models.dart';
import '../../chat/chat.dart';

class MessageTile extends StatelessWidget {
  final MessageInfoModel messageInfo;
  const MessageTile({
    Key? key,
    required this.messageInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatView(
                contactModel: ContactModel(
              lastName: messageInfo.lastName,
              firstName: messageInfo.firstName,
              avatarUrl: '',
              occupation: '',
              serverId: messageInfo.messageServerId,
              id: messageInfo.messageId,
            )),
          ),
        );
      },
      // leading: Container(
      //   height: 35,
      //   width: 35,
      //   decoration: const BoxDecoration(
      //     shape: BoxShape.circle,
      //   ),
      //   child: Image.network(messageInfo.avatar),
      // ),
      title: AppText.bodyLarge(messageInfo.firstName),
      subtitle: AppText.body(messageInfo.message),
      trailing: Column(children: [
        AppText.caption(
          timeago.format(
            messageInfo.timestamp,
          ),
        ),
        messageInfo.isMe
            ? AppText.caption(messageInfo.status)
            : AppText.caption(
                messageInfo.unreadMessages == 0
                    ? ''
                    : messageInfo.unreadMessages.toString(),
              )
      ]),
    );
  }
}
