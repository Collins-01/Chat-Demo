// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../core/models/models.dart';

class MessageTile extends StatelessWidget {
  final MessageInfoModel messageInfo;
  const MessageTile({
    Key? key,
    required this.messageInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 35,
        width: 35,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Image.network(messageInfo.avatar),
      ),
      title: Text("${messageInfo.lastName} ${messageInfo.firstName}"),
      subtitle: Text(messageInfo.message ?? messageInfo.messageType!),
      trailing: Text(
        messageInfo.timestamp.toLocal().toString(),
      ),
    );
  }
}
