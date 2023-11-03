import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

// Create a model for location entries
class LocationEntry {
  int? id;
  final String address;
  final DateTime startTime;
  DateTime? endTime; // Updated to allow setting 'endTime'

  LocationEntry({this.id, required this.address, required this.startTime, this.endTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }

  static LocationEntry fromMap(Map<String, dynamic> map) {
    return LocationEntry(
      id: map['id'] as int?,
      address: map['address'],
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
    );
  }
}

// Database helper class
class LocationDatabase {
  static final LocationDatabase instance = LocationDatabase._init();

  static Database? _database;

  LocationDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('location_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    await db.execute('''
CREATE TABLE locations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  address TEXT NOT NULL,
  startTime TEXT NOT NULL,
  endTime TEXT  -- Explicitly allowing NULL values for endTime
)
''');
  }

  Future<int> create(LocationEntry location) async {
    final db = await instance.database;
    final id = await db.insert('locations', location.toMap());
    return id;
  }

  Future<List<LocationEntry>> readAllLocations() async {
    final db = await instance.database;
    final result = await db.query('locations', orderBy: 'startTime DESC');
    return result.map((json) => LocationEntry.fromMap(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
  Future<int> update(LocationEntry location) async {
    final db = await instance.database;

    return await db.update(
      'locations',
      location.toMap(),
      where: 'id = ?',
      whereArgs: [location.id],
    );
  }
}

class LocationHistoryScreen extends StatefulWidget {
  @override
  _LocationHistoryScreenState createState() => _LocationHistoryScreenState();
}

class _LocationHistoryScreenState extends State<LocationHistoryScreen> {
  List<LocationEntry> locations = [];
  final DateFormat formatter = DateFormat('hh:mm a');

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _listenToLocationChanges();
  }

  _loadLocations() async {
    locations = await LocationDatabase.instance.readAllLocations();
    setState(() {});
  }

  _listenToLocationChanges() {
    final locationStream = Geolocator.getPositionStream();
    LocationEntry? currentLocationEntry;

    locationStream.listen((Position position) async {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          final Placemark placemark = placemarks.first;
          final address = "${placemark.name}, ${placemark.locality}, ${placemark.country}";

          if (currentLocationEntry == null || currentLocationEntry!.address != address) {
            if (currentLocationEntry != null) {
              // Check if endTime is not null before updating
              if (currentLocationEntry!.endTime == null) {
                currentLocationEntry!.endTime = DateTime.now();
                await LocationDatabase.instance.update(currentLocationEntry!);
              }
            }

            final newEntry = LocationEntry(address: address, startTime: DateTime.now());
            final id = await LocationDatabase.instance.create(newEntry);
            newEntry.id = id;
            currentLocationEntry = newEntry;

            setState(() {
              locations.insert(0, newEntry);
            });
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }


  String formattedTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return "${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period";
  }

  String sanitizeAddress(String address) {
    return address.replaceAll(' ,', ',').replaceAll(', ,', ',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location History"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: locations.isEmpty
            ? Center(child: Text("No locations found"))
            : ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.location_on),
                title: Text(sanitizeAddress(locations[index].address)),
                subtitle: Text(
                    '${formattedTime(locations[index].startTime)} - ${locations[index].endTime != null ? formattedTime(locations[index].endTime!) : 'Now'}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
