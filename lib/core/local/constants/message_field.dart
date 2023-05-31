class MessageField {
  /// message id for the creation on the local sql table. [int]
  static String id = 'id';

  /// contains the text content of the message [String]
  static String content = 'content';

  /// Describes the type of message sent. `image, text, audio, video`
  static String messageType = 'message_type';

  /// Describes the type of media for the sent message. `image, text, audio, video`
  static String mediaType = 'media_type';

  /// Date the message was created [Date]
  static String createdAt = 'created_at';

  ///Date the message was updated [Date]
  static String updatedAt = 'updated_at';

  /// Describes the id for the message generated on the server. [uuidv4]
  static String severId = 'sever_id';

  /// Describes the local id of the message [uuidv4]
  static String localId = 'local_id';

  /// Path to the media file on the Cloud Storage [String `http://cloudstorage/chatmedia`]
  static String mediaUrl = 'media_url';

  /// Path to the media file that exists on the local machine [String `applicaltion path/chatmedia/ images`]
  static String localMediaPath = 'local_media_path';

  ///
  static String chatId = 'chat_id';

  /// Used to idicate the sender of a particular message [uuidv4]
  static String sender = 'sender';

  /// Used to indicate the receiver of a particular message [uuidv4]
  static String receiver = 'receiver';

  /// Used to indicate the status of a particular message [`sent` ,`failed` , `delivered`, `received`]
  static String status = 'status';
}
