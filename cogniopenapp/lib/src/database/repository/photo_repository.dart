import 'package:cogniopenapp/src/database/app_database.dart';
import 'package:cogniopenapp/src/database/model/media.dart';
import 'package:cogniopenapp/src/database/model/photo.dart';

class PhotoRepository {
  static final PhotoRepository instance = PhotoRepository._init();

  PhotoRepository._init();

  Future<Photo> create(Photo photo) async {
    final db = await AppDatabase.instance.database;

    final id = await db.insert(tablePhotos, photo.toJson());

    return photo.copy(id: id);
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;

    return await db.delete(
      tablePhotos,
      where: '${MediaFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<Photo> read(int id) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      tablePhotos,
      columns: MediaFields.values,
      where: '${MediaFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Photo.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Photo>> readAll() async {
    final db = await AppDatabase.instance.database;

    const orderBy = '${MediaFields.id} ASC';
    final result = await db.query(tablePhotos, orderBy: orderBy);

    return result.map((json) => Photo.fromJson(json)).toList();
  }

  Future<int> update(Photo photo) async {
    final db = await AppDatabase.instance.database;

    return db.update(
      tablePhotos,
      photo.toJson(),
      where: '${MediaFields.id} = ?',
      whereArgs: [photo.id],
    );
  }
}