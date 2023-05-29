class SqlParams {
  static const String databaseName = "ChatDB011";
  static const int databaseVersion = 1;
  static const String contactTable = "contactTable";
  static const String messageTable = "messageTable";

  static String createContactsTableQuery = '''
     CREATE TABLE IF NOT EXISTS $contactTable (
    id TEXT PRIMARY KEY,
    lastName TEXT NOT NULL,
    firstName TEXT NOT NULL,
    avatarUrl TEXT NOT NULL
  )
''';

  static String createMessageTableQuery = '''
  CREATE TABLE IF NOT EXISTS $messageTable (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT NOT NULL,
    local_id TEXT NOT NULL,
    remote_id INTEGER NOT NULL,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    status INTEGER NOT NULL,
    sender TEXT NOT NULL,
    receiver TEXT NOT NULL
  )
''';
}
