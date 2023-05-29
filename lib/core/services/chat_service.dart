import 'package:harmony_chat_demo/core/dtos/send_message_dto.dart';
import 'package:harmony_chat_demo/core/models/message_model.dart';
import 'package:harmony_chat_demo/core/services/database_service.dart';
import 'package:harmony_chat_demo/utils/sql_params.dart';
import 'package:path/path.dart';
import 'package:sqlbrite/sqlbrite.dart';

class ChatService {
  late DatabaseService _databaseService;
  Future _onCreate(Database db, int version) async {
    // create contact table in the database
    await db.execute(SqlParams.createContactsTableQuery);

    // create message table in the database
    await db.execute(SqlParams.createMessageTableQuery);
  }

  Future<Database> _initDatabase() async {
    // get database directory
    final documentDirectory = await getDatabasesPath();
    // get path to databas file
    final path = join(documentDirectory, SqlParams.databaseName);

    // open database with path
    // set database version
    // set the onCreate function is called
    // when database is newly created
    return openDatabase(path,
        version: SqlParams.databaseVersion, onCreate: _onCreate);
  }

  Future<void> initialize() async {
    _databaseService = DatabaseService(await _initDatabase());
  }

  Future<void> deleteDatabase() async {
    final documentDirectory = await getDatabasesPath();
    final path = join(documentDirectory, SqlParams.databaseName);
    await databaseFactory.deleteDatabase(path);
    await _initDatabase();
  }

  sendMessage(MessageModel message) {
    return _databaseService.insertMessage(message);
  }
}
