import 'package:harmony_chat_demo/core/local/chat_repository/chat_repository_interface.dart';

class ChatRepositoyImpl implements ChatRepository {
  @override
  Future<void> deleteDatabase() async {
    throw UnimplementedError();
  }

  @override
  Future<void> initialize() {
    // TODO: implement initialize
    throw UnimplementedError();
  }
}
