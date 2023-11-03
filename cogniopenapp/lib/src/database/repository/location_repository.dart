import 'package:cogniopenapp/src/database/app_database.dart';
import 'package:cogniopenapp/src/database/model/media.dart';
import 'package:cogniopenapp/src/database/model/location.dart';

// const String tableLocations = 'locations';

class LocationFields extends MediaFields {
  static final List<String> values = [
    ...MediaFields.values,
    latitude,
    longitude,
    address,
    timestamp,
  ];

  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
  static const String address = 'address';
  static const String timestamp = 'timestamp';
}

class LocationRepository {
  static final LocationRepository instance = LocationRepository._init();

  LocationRepository._init();

  Future<Location> create(Location location) async {
    final db = await AppDatabase.instance.database;

    final id = await db.insert(tableLocations, location.toJson());

    return location.copy(id: id);
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;

    return await db.delete(
      tableLocations,
      where: '${MediaFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<Location> read(int id) async {
    final db = await AppDatabase.instance.database;

    final maps = await db.query(
      tableLocations,
      where: '${MediaFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Location.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Location>> readAll() async {
    final db = await AppDatabase.instance.database;

    const orderBy = '${MediaFields.id} ASC';
    final result = await db.query(tableLocations, orderBy: orderBy);

    return result.map((json) => Location.fromJson(json)).toList();
  }

  Future<int> update(Location location) async {
    final db = await AppDatabase.instance.database;

    return db.update(
      tableLocations,
      location.toJson(),
      where: '${MediaFields.id} = ?',
      whereArgs: [location.id],
    );
  }
}
