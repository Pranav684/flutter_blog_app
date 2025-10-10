import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String dbName = "blogify.db";
const String tableName = "users";

class LocalDb {
  static Database? _db;

  // Open or create database
  static Future<Database?> _openDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    try {
      return openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE users (
            _id TEXT PRIMARY KEY,
            fullName TEXT,
            email TEXT,
            profileImageUrl TEXT,
            role TEXT
          )
        ''');
        },
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  //  Get db instance
  static Future<Database?> get database async {
    try {
      _db = await _openDB();
      return _db;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // save user data
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final db = await database;
      await db!.insert(
        tableName,
        userData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
    }
  }

  //  get first user
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final db = await database;
      final result = await db!.query(tableName, limit: 1);
      print(result.first);
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print(e);
    }
  }

  // Delete user (logout)
  static Future<void> deleteUser() async {
    try {
      final db = await database;
      await db!.delete(tableName);
    } catch (e) {
      print(e);
    }
  }
}
