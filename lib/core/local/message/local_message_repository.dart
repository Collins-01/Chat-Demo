import 'package:harmony_chat_demo/core/models/message_model.dart';

abstract class LocalMessageRepository {
  Future<void> insertMessage(MessageModel message);

  Future<void> deleteMessage(MessageModel message);

  Future<void> updateMessage(MessageModel message);

  Future<void> updateAllMessage(List<MessageModel> messages);

  Future<void> insertAllMessage(List<MessageModel> messages);
}
