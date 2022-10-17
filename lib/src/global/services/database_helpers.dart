import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/database_strings.dart';
import '../models/spending_entry.dart';

class DatabaseHelper {
  static final _databaseName = "SpendingDatabase.db";
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableSpending (
                $columnId INTEGER PRIMARY KEY,
                $columnTimeStamp INTEGER NOT NULL,
                $columnDay INTEGER NOT NULL,
                $columnAmount REAL NOT NULL,
                $columnContent TEXT NOT NULL
              )
              ''');
  }

  Future<int> insertSpending(SpendingEntry entry) async {
    Database db = await database;
    int id = await db.insert(tableSpending, entry.toMap());
    return id;
  }

  Future<SpendingEntry?> querySpending(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableSpending,
        columns: [
          columnId,
          columnTimeStamp,
          columnDay,
          columnAmount,
          columnContent
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return SpendingEntry.fromMap(maps.first);
    }
    return null;
  }

  // Get all items from today
  Future<List<SpendingEntry>> queryDay(num day) async {
    Database db = await database;
    List<Map> maps = await db.query(tableSpending,
        columns: [
          columnId,
          columnTimeStamp,
          columnDay,
          columnAmount,
          columnContent
        ],
        where: '$columnDay = ?',
        whereArgs: [day]);
    List<SpendingEntry> result = <SpendingEntry>[];
    if (maps.length > 0) {
      for (Map i in maps) {
        result.add(SpendingEntry.fromMap(i));
      }
      return result;
    }
    return <SpendingEntry>[];
  }

  Future<int> deleteSingleEntry(int id) async {
    Database db = await database;
    return await db
        .delete(tableSpending, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateSingleEntry(SpendingEntry entry) async {
    Database db = await database;
    return await db.update(tableSpending, entry.toMap(),
        where: '$columnId = ?', whereArgs: [entry.id]);
  }

  Future<List<SpendingEntry>> queryAllSpending() async {
    Database db = await database;
    List<Map> maps = await db.rawQuery('SELECT * FROM $tableSpending');
    List<SpendingEntry> result = <SpendingEntry>[];
    if (maps.length > 0) {
      for (Map i in maps) {
        result.add(SpendingEntry.fromMap(i));
      }
      return result;
    }
    return <SpendingEntry>[];
  }

  Future<int> clearSpendingTable() async {
    Database db = await database;
    return await db.delete(tableSpending);
  }
}
