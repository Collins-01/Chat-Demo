import 'package:harmony_chat_demo/core/models/message_model.dart';

import '../../models/contact_model.dart';

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

  /// Get the last message sent by [contact].
  Future<MessageModel?> getContactLastMessage(ContactModel contact);

  /// Get all message sent by [contact].
  Future<List<MessageModel>> getContactMessages(ContactModel contact);

  /// Get all media messages that have not been completely uploaded/downloaded.
  Future<List<MessageModel>> getMediaMessagesInUploadOrDownloadState();

  /// Emits all message messages containing a media file in conversation with
  /// this chat id -> `chatId`.
  Stream<List<MessageModel>> watchMediaMessages(String chatId);

  /// Get all unsent messages.
  Future<List<MessageModel>> getUnsentMessages();

  /// Emits the list of messages sent by this [contact] whenever
  /// there is an update.
  Stream<List<MessageModel>> watchContactMessages(ContactModel contact);

  /// Get message with [id].
  Future<MessageModel?> getMessageById(String id);

  /// Get message with [localId].
  Future<MessageModel?> getMessageByLocalId(String localId);

  /// get unread messages sent by user with id [contactId]
  /// in chat with [chatId]
  Future<List<MessageModel>> getUnreadMessagesByChatId({
    required String chatId,
    required String contactId,
  });

  ///This would only change all message from [senderId] to [receiverId]
  /// on or before date with ```message.isRead =false```
  Future<int> bulkRead({
    required DateTime date,
    required String senderId,
    required String receiverId,
  });
}
