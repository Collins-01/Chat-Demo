import 'package:harmony_chat_demo/core/local/constants/contact_field.dart';
import 'package:harmony_chat_demo/core/local/constants/message_field.dart';

class DBConstants {
  static const String databaseName = 'harmony_chat_demo.db';
  static const int dbVersion = 1;
  static const String contactTable = "contactTable";
  static const String messageTable = "messageTable";

  static String createContactsTable = ''' 
    CREATE TABLE $contactTable (
    ${ContactField.id} Text PRIMARY KEY NOT NULL,
    ${ContactField.firstName} VARCHAR(255) NOT NULL,
    ${ContactField.lastName} VARCHAR(255) NOT NULL,
    ${ContactField.avatar} VARCHAR(255) NOT NULL,
    ${ContactField.serverId} VARCHAR(255) NOT NULL,
    ${ContactField.occupation} VARCHAR(255) NOT NULL
    
)

    ''';
  // ${ContactField.bio} VARCHAR(255) NOT NULL,
// ${ContactField.createdAt} DATETIME NOT NULL
  static String createMessagesTable = '''

    CREATE TABLE $messageTable (
        ${MessageField.id} Text PRIMARY KEY NOT NULL ,
        ${MessageField.content} TEXT,
        ${MessageField.messageType} VARCHAR(36) NOT NULL,
        ${MessageField.mediaType}  VARCHAR(36) ,
        ${MessageField.status} VARCHAR(36) NOT NULL,
        ${MessageField.createdAt} DATETIME NOT NULL,
        ${MessageField.updatedAt} DATETIME NOT NULL,
        ${MessageField.serverId} VARCHAR(36),
        ${MessageField.localId} VARCHAR(36) UNIQUE  NOT NULL ,
        ${MessageField.mediaId} VARCHAR(36),
        ${MessageField.mediaUrl} VARCHAR(255),
        ${MessageField.localMediaPath} VARCHAR(255),
        ${MessageField.chatId} VARCHAR(36),
        ${MessageField.sender} VARCHAR(36) NOT NULL,
        ${MessageField.receiver} VARCHAR(36) NOT NULL,
        ${MessageField.isDownloadingMedia}  INT ,
        ${MessageField.failedToUploadMedia}  INT ,
        ${MessageField.isDeleted}  INT ,
        ${MessageField.isUploadingMedia}  INT ,
        ${MessageField.failedToDownloadMedia}  INT 
        

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
            m.${MessageField.updatedAt},
            m.${MessageField.status},
            m.${MessageField.mediaType},
            m.${MessageField.sender},
            m.${MessageField.receiver}
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
        
      ''';
}
// ORDER BY ${ContactField.createdAt} DESC