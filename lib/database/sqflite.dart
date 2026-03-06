import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'nandur_id.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE plants (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            plantName TEXT, 
            description TEXT, 
            category TEXT, 
            wateringIntervalDays INTEGER, 
            fertilizingIntervalDays INTEGER
            lastWatered TEXT
            createdAt TEXT
            FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
          )
        ''');

        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            fullName TEXT, 
            email TEXT UNIQUE, 
            password TEXT, 
            location TEXT, 
            dob TEXT, 
            gender TEXT,
            createdAt TEXT
          )
        ''');
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      version: 1,
    );
  }
}
