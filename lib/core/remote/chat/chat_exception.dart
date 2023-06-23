// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatException with Exception {
  final String title;
  final String message;
  ChatException({
    this.title = "Error",
    required this.message,
  });
}
