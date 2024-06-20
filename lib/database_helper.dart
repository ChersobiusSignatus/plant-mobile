
//database_helper.dart

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'modules/plant.dart';
import 'modules/current_values.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'plants_database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE plants_info (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT CHECK(type IN ('beginner friendly', 'medium', 'intermediate')) NOT NULL,
        light REAL,
        water REAL,
        temp REAL,
        origin TEXT,
        planting TEXT,
        image_url TEXT,
        watering_frequency INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE current_values (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plant_id INTEGER,
        light REAL,
        water REAL,
        temp REAL,
        last_watering_day TEXT NOT NULL,
        FOREIGN KEY (plant_id) REFERENCES plants_info(id)
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE plants_info ADD COLUMN watering_frequency INTEGER NOT NULL DEFAULT 7');
      await db.execute('ALTER TABLE current_values ADD COLUMN last_watering_day TEXT');

      // Initialize last_watering_day for existing rows
      final List<Map<String, dynamic>> maps = await db.query('current_values');
      for (var map in maps) {
        await db.update(
          'current_values',
          {'last_watering_day': DateTime.now().toIso8601String()},
          where: 'id = ?',
          whereArgs: [map['id']],
        );
      }
    }
  }

  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
    }
  }

  Future<int> insertPlant(Plant plant) async {
    final db = await database;
    return await db.insert('plants_info', plant.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Plant>> plants() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('plants_info');

    return List.generate(maps.length, (i) {
      return Plant.fromMap(maps[i]);
    });
  }

  Future<int> insertCurrentValue(CurrentValue currentValue) async {
    final db = await database;
    return await db.insert('current_values', currentValue.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CurrentValue>> currentValues(int plantId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'current_values',
      where: 'plant_id = ?',
      whereArgs: [plantId],
    );

    return List.generate(maps.length, (i) {
      return CurrentValue.fromMap(maps[i]);
    });
  }
}
