import 'package:cogniopenapp/src/database/app_database.dart';
import 'package:cogniopenapp/src/database/model/media.dart';
import 'package:cogniopenapp/src/database/model/conversation.dart';

class ConversationRepository {
  static final ConversationRepository instance = ConversationRepository._init();

  ConversationRepository._init();

  Future<Conversation> create(Conversation conversation) async {
    final db = await AppDatabase.instance.database;

    final id = await db.insert(tableConversations, conversation.toJson());

    return conversation.copy(id: id);
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;

    return await db.delete(
      tableConversations,
      where: '${MediaFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<Conversation> read(int id) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      tableConversations,
      columns: ConversationFields.values,
      where: '${MediaFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Conversation.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Conversation>> readAll() async {
    final db = await AppDatabase.instance.database;

    const orderBy = '${MediaFields.id} ASC';
    final result = await db.query(tableConversations, orderBy: orderBy);

    return result.map((json) => Conversation.fromJson(json)).toList();
  }

  Future<int> update(Conversation conversation) async {
    final db = await AppDatabase.instance.database;

    return db.update(
      tableConversations,
      conversation.toJson(),
      where: '${MediaFields.id} = ?',
      whereArgs: [conversation.id],
    );
  }
}
