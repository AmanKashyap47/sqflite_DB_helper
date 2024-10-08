import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static DBHelper getInstance() => DBHelper._();

  Database? database;

  static final String TABLE_NOTE_NAME = "note";
  static final String COLUMN_NOTE_ID = "id";
  static final String COLUMN_NOTE_TITLE = "name";
  static final String COLUMN_NOTE_DESC = "desc";

  // getDB

  Future<Database> getDB() async {
    if (database != null) {
      return database!;
    } else {
      database = await openDB();
      return database!;
    }
  }

  Future<Database> openDB() async {
    var appDir = await getApplicationDocumentsDirectory();
    var dbPath = join(appDir.path, "Note.db");
    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute(
          "create table $TABLE_NOTE_NAME ( $COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text ) ");
    });
  }

  Future<bool> addNote({required String title, required String desc}) async {
    var db = await getDB();
    int rowEffected = await db.insert(TABLE_NOTE_NAME, {
      COLUMN_NOTE_TITLE: title,
      COLUMN_NOTE_DESC: desc,
    });
    return rowEffected > 0;
  }

  // get allNotes
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE_NAME);
    return mData;
  }
}
