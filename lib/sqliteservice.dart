import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'data.dart';

class SqliteService{
  static const String databaseName = "memory_map.db";
  static Database? db;

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
    await database.execute("""CREATE TABLE IF NOT EXISTS Notes (
        Id TEXT NOT NULL,
        Title TEXT NOT NULL,
        Description TEXT NOT NULL,
      )      
      """);
  }

  static Future<int> createItem(Location note) async {
    final db = await SqliteService.initializeDb();

    final id = await db.insert('Notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<Location>> getItems() async {
    final db = await SqliteService.initializeDb();
    final List<Map<String, Object?>> queryResult =
    await db.query('Notes');
    return queryResult.map((e) => Location.fromMap(e)).toList();
  }

  Future<int> updateNote(int id, Location item) async{ // returns the number of rows updated

    final db = await initializeDb();

    int result = await db.update(
        "Notes",
        item.toMap(),
        where: "id = ?",
        whereArgs: [id]
    );
    return result;
  }

  // Delete an note by id
  Future<void> deleteItem(String id) async {
    final db = await SqliteService.initializeDb();
    try {
      await db.delete("Notes", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}