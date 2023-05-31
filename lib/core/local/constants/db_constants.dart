import 'package:harmony_chat_demo/core/enums/media_type.dart';
import 'package:harmony_chat_demo/core/enums/message_type.dart';
import 'package:harmony_chat_demo/core/local/constants/contact_field.dart';
import 'package:harmony_chat_demo/core/local/constants/message_field.dart';
import '../../enums/message_status.dart';

class DBConstants {
  static const String databaseName = 'harmony_chat_demo.db';
  static const int dbVersion = 1;
  static const String contactTable = "contactTable";
  static const String messageTable = "messageTable";

  static String createContactsTable = ''' 
    CREATE TABLE $contactTable (
    ${ContactField.id} INT PRIMARY KEY AUTO_INCREMENT,
    ${ContactField.firstName} VARCHAR(255) NOT NULL,
    ${ContactField.lastName} VARCHAR(255) NOT NULL,
    ${ContactField.avatar} VARCHAR(255) NOT NULL,
    ${ContactField.serverId} VARCHAR(255) NOT NULL,
    ${ContactField.bio} VARCHAR(255) NOT NULL,
    ${ContactField.occupation} VARCHAR(255) NOT NULL
)

    ''';

  static String createMessagesTable = '''

    CREATE TABLE $messageTable (
        ${MessageField.id} INT PRIMARY KEY AUTO_INCREMENT,
        ${MessageField.content} TEXT,
        ${MessageField.messageType} ENUM(${MessageType.audio.name}, ${MessageType.video.name},  ${MessageType.image.name}, ${MessageType.text}) NOT NULL,
        ${MessageField.mediaType} ENUM(${MediaType.audio.name}, ${MediaType.video.name},  ${MediaType.image.name}, ${MediaType.document.name}) NOT NULL,
        ${MessageField.status} ENUM (${MessageStatus.failed.name}, ${MessageStatus.sent.name}, ${MessageStatus.delivered.name}, ${MessageStatus.read.name}) NOT NULL,
        ${MessageField.createdAt} DATETIME NOT NULL,
        ${MessageField.updatedAt} DATETIME NOT NULL,
        ${MessageField.severId} VARCHAR(36),
        ${MessageField.localId} VARCHAR(36) NOT NULL,
        ${MessageField.mediaUrl} VARCHAR(255),
        ${MessageField.localMediaPath} VARCHAR(255),
        ${MessageField.chatId} VARCHAR(36),
        ${MessageField.sender} VARCHAR(36) NOT NULL,
        ${MessageField.receiver} VARCHAR(36) NOT NULL
)


 ''';

  /// Gets the last conversations for the current user of the device.
  static String getLastConversations = '''
          SELECT
            c.${ContactField.id},
            c.${ContactField.lastName},
            c.${ContactField.firstName},
            c.${ContactField.avatar},
            c.${ContactField.bio},
            m.${MessageField.content},
            m.${MessageField.updatedAt}
            m.${MessageField.status}
            m.${MessageField.mediaType}
          FROM
            $contactTable AS c
            JOIN $messageTable AS m ON (
              m.${MessageField.sender} = c.${ContactField.id}
              OR m.${MessageField.receiver} = c.${ContactField.id}
            )
          WHERE
            m.${MessageField.updatedAt} = (
              SELECT
                MAX(${MessageField.updatedAt})
              FROM
                $messageTable
              WHERE
                (
                  m.${MessageField.sender} = c.${ContactField.id}
                  OR m.${MessageField.receiver} = c.${ContactField.id}
                )
            )
          ORDER BY
            m.${MessageField.updatedAt} DESC;
     ''';

  /// Get contaact that match [contactUsernamePattern]
  static String contactRawQuery([String? contactUsernamePattern]) => '''
        SELECT  *  FROM $contactTable 
        ORDER BY ${ContactField.createdAt} DESC
      ''';
}
