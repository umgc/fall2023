import 'package:cogniopenapp/src/database/app_database_seed_data.dart';
import 'package:cogniopenapp/src/database/model/media.dart';
import 'package:cogniopenapp/src/database/repository/audio_repository.dart';
import 'package:cogniopenapp/src/database/repository/photo_repository.dart';
import 'package:cogniopenapp/src/database/repository/video_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const textNullableType = 'TEXT';

    final mediaColumns = [
      '${MediaFields.id} $idType',
      '${MediaFields.title} $textNullableType',
      '${MediaFields.description} $textNullableType',
      '${MediaFields.tags} $textNullableType',
      '${MediaFields.timestamp} $integerType',
      '${MediaFields.fileName} $textType',
      '${MediaFields.storageSize} $integerType',
      '${MediaFields.isFavorited} $boolType',
    ];

    await db.execute('''
      CREATE TABLE $tableAudios (
        ${mediaColumns.join(',\n')},
        ${AudioFields.summary} $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE $tablePhotos (
        ${mediaColumns.join(',\n')}
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableVideos (
        ${mediaColumns.join(',\n')},
        ${VideoFields.duration} $textNullableType,
        ${VideoFields.thumbnail} $textNullableType
      )
    ''');

    final appDatabaseSeedData = AppDatabaseSeedData();
    appDatabaseSeedData.insertAppDatabaseSeedData();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
