import 'package:harmony_chat_demo/core/models/message_model.dart';

abstract class LocalMessageRepository {
  /// Inserts a message in the the `messages` table.
  Future<void> insertMessage(MessageModel message);

  ///Deletes a message in the the `messages` table.
  ///NB: Messages won't be deleted, the status will only be changed to deleted
  Future<void> deleteMessage(MessageModel message);

  /// Updates a message in the the `messages` table.
  Future<void> updateMessage(MessageModel message);

  /// Updates multiple messages in the `messages` table.
  Future<void> updateAllMessages(List<MessageModel> messages);

  /// Inserts multiple messages in the `messages` table.
  Future<void> insertAllMessage(List<MessageModel> messages);
}
