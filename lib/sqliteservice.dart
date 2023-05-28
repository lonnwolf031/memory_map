import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'locationdata.dart';

class SqliteService{
  static const String databaseName = "memory_map.db";
  static Database? db;
  static const String locationTableName = "locations";

  static Future<Database> initializeDb() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return db?? await openDatabase(
        path,
        version: 2,
        onCreate: (Database db, int version) async {
          await createTables(db);
        });
  }

  static Future<void> createTables(Database database) async{
    await database.execute("""CREATE TABLE IF NOT EXISTS $locationTableName (
        ${LocationColumn.id} INTEGER PRIMARY KEY,
        ${LocationColumn.lat} TEXT NOT NULL,
        ${LocationColumn.lon} TEXT NOT NULL,
        ${LocationColumn.title} TEXT NOT NULL,
        ${LocationColumn.description} TEXT NOT NULL
      )      
      """);
  }

  static Future<int> createItem(Location location) async {
    final db = await SqliteService.initializeDb();
    final id = await db.insert(locationTableName, location.insert(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Location>> getItems() async {
    final db = await SqliteService.initializeDb();
    final List<Map<String, dynamic>> maps = await db.query(locationTableName);
    return List.generate(maps.length, (index) => Location.fromMap(maps[index]));
  }

  static Future<int> updateLocation(int id, Location item) async{ // returns the number of rows updated
    final db = await initializeDb();
    int result = await db.update(
        locationTableName,
        item.update(),
        where: "id = ?",
        whereArgs: [id]
    );
    return result;
  }

  // Delete an item by id
  static Future<void> deleteItem(String id) async {
    final db = await SqliteService.initializeDb();
    try {
      await db.delete(locationTableName, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}