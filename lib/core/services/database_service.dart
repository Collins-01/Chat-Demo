import 'package:harmony_chat_demo/core/models/message_field.dart';
import 'package:harmony_chat_demo/utils/sql_params.dart';
import 'package:sqlbrite/sqlbrite.dart';

import '../models/message_model.dart';

class DatabaseService {
  final BriteDatabase _streamDatabase;
  final Database _database;

  // ignore: non_constant_identifier_names

  DatabaseService(this._database) : _streamDatabase = BriteDatabase(_database);

  Future<int> delete(
    String table,
    String id, {
    String fieldname = "id",
  }) async {
    // *============= Delete =================
    return _streamDatabase.delete(
      table,
      where: "$fieldname = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteMessage(MessageModel message) {
    return delete(
      SqlParams.messageTable,
      message.localId,
      fieldname: MessageField.localId,
    );
  }

// * ============== Insert =============================
  Future<int> insert(String table, Map<String, dynamic> rowData,
      [bool ignoreConflict = false]) {
    return _streamDatabase.insert(table, rowData,
        conflictAlgorithm: ignoreConflict
            ? ConflictAlgorithm.ignore
            : ConflictAlgorithm.replace);
  }

  Future<void> insertMessage(MessageModel message) async {
    await insert(SqlParams.messageTable, message.toDBMap(), false);
  }

  Future<void> insertAllMessages(List<MessageModel> messages) async {
    final batch = _streamDatabase.batch();
    for (var message in messages) {
      batch.insert(SqlParams.messageTable, message.toDBMap());
    }
    await batch.commit(noResult: true);
  }

// * ================== Update =================
  Future<int> update(
    String table,
    Map<String, dynamic> rowData, {
    String? where,
    List<Object?>? whereArgs,
    bool ignoreConflict = false,
  }) {
    return _streamDatabase.update(
      table,
      rowData,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm:
          ignoreConflict ? ConflictAlgorithm.ignore : ConflictAlgorithm.replace,
    );
  }

  Future<int> updateMessage(MessageModel message) {
    return update(
      SqlParams.messageTable,
      message.toDBMap(),
      where: "${MessageField.localId} = ?",
      whereArgs: [message.localId],
    );
  }

  Future<int> updateMessageStatus(int messageId, MessageStatus status) {
    return update(SqlParams.messageTable, {"status": status},
        where: "${MessageField.id} = ?", whereArgs: [messageId]);
  }
}
