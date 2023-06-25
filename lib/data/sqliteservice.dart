import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:memory_map/data/imagedata.dart';
import 'package:memory_map/data/tagdata.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'locationdata.dart';

class SqliteService{
  static const String databaseName = "memory_map.db";
  static Database? db;
  static const String locationTableName = "locations";
  static const String tagTableName = "tags";
  static const String imageTableName = "images";

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
        ${LocationColumns.id} INTEGER PRIMARY KEY,
        ${LocationColumns.lat} TEXT NOT NULL,
        ${LocationColumns.lon} TEXT NOT NULL,
        ${LocationColumns.title} TEXT NOT NULL,
        ${LocationColumns.description} TEXT NOT NULL
      )      
      """);

    await database.execute(
        """CREATE TABLE IF NOT EXISTS $tagTableName (
        ${TagColumns.id} INTEGER PRIMARY KEY,
        ${TagColumns.title} TEXT NOT NULL,
        ${TagColumns.color} TEXT NOT NULL
      )      
      """);

    await database.execute(
        """CREATE TABLE IF NOT EXISTS $imageTableName (
        ${ImageColumns.id} INTEGER PRIMARY KEY,
        ${ImageColumns.data} BLOB NOT NULL,
        ${ImageColumns.locationId}  INTEGER NOT NULL,
        FOREIGN KEY (${ImageColumns.locationId})
           REFERENCES $locationTableName  (${LocationColumns.id}) 
          )      
      """);

  }

  static Future<int> createLocationItem(Location location) async {
    final db = await SqliteService.initializeDb();
    final id = await db.insert(locationTableName, location.insert(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> createImageItem(ImageData image) async {
    final db = await SqliteService.initializeDb();
    final id = await db.insert(imageTableName, image.insert(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Location>> getLocationByGeoPoint(GeoPoint p)  async {
    final db = await SqliteService.initializeDb();
    final List<Map<String, dynamic>> maps = await db.query(
         locationTableName,
          where: "${LocationColumns.lat} = ? AND ${LocationColumns.lon} = ?",
          whereArgs: [p.latitude, p.longitude],
          orderBy: LocationColumns.id,
          limit: 10,
      );
    return List.generate(maps.length, (index) => Location.fromMap(maps[index]));
  }

  static Future<List<Location>> getLocationItems() async {
    final db = await SqliteService.initializeDb();
    final List<Map<String, dynamic>> maps = await db.query(locationTableName);
    return List.generate(maps.length, (index) => Location.fromMap(maps[index]));
  }

  static Future<List<Tag>> getTagItems() async {
    final db = await SqliteService.initializeDb();
    final List<Map<String, dynamic>> maps = await db.query(tagTableName);
    return List.generate(maps.length, (index) => Tag.fromMap(maps[index]));
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