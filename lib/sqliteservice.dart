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
        version: 1,
        onCreate: (Database db, int version) async {
          await createTables(db);
        });
  }

  static Future<void> createTables(Database database) async{
    await database.execute("""CREATE TABLE IF NOT EXISTS $locationTableName (
        Id INTEGER PRIMARY KEY,
        Lat TEXT NOT NULL,
        Lon TEXT NOT NULL,
        Title TEXT NOT NULL,
        Description TEXT NOT NULL
      )      
      """);
  }

  static Future<int> createItem(Location location) async {
    final db = await SqliteService.initializeDb();

    final id = await db.insert(locationTableName, location.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Location>> getItems() async {
    final db = await SqliteService.initializeDb();
    //final List<Map<String, Object?>> queryResult =
    //await db.query(locationTableName);
    /*
    return queryResult.map((e) => Location.fromMap(e)).toList();

    // Query the table for all The Dogs.

     */
    final List<Map<String, dynamic>> maps = await db.query(locationTableName);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Location.fromDB(
        id: maps[i][LocationColumn.id],
        lat: maps[i][LocationColumn.lat],
        lon: maps[i][LocationColumn.lon],
        title: maps[i][LocationColumn.title],
        description: maps[i][LocationColumn.description]
      );
    });
  }

  static Future<int> updateLocation(int id, Location item) async{ // returns the number of rows updated

    final db = await initializeDb();

    int result = await db.update(
        locationTableName,
        item.toMap(),
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