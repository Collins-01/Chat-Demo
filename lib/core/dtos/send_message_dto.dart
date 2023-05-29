// ignore_for_file: public_member_api_docs, sort_constructors_first
class SendMessageDto {
  String sender;
  String receiver;
  String localId;
  String content;
  SendMessageDto({
    required this.sender,
    required this.receiver,
    required this.localId,
    required this.content,
  });
}
