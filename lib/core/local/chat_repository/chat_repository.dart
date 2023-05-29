import 'package:harmony_chat_demo/core/local/contatct/local_contacts_repository.dart';
import 'package:harmony_chat_demo/core/local/message/local_message_repository.dart';

abstract class ChatRepository
    with LocalContactsRepository, LocalMessageRepository {
  Future<void> initialize();
  Future<void> deleteDatabase();
}
