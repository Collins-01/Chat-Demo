abstract class ChatRepository {
  Future<void> initialize();
  Future<void> deleteDatabase();
}
