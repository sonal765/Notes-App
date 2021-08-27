//now let's make the Db provider  class

import 'dart:io';

// import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/notes_model.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  static Database _database;
  DatabaseProvider();
  String dbTable = 'notes';

  //creating the getter the database
  Future<Database> get database async {
    //
    if (_database != null) {
      return _database;
    }
    _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes_app.db';
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $dbTable(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,body TEXT, date DATE)');
  }

  // initDB() async {
  //   return await openDatabase(join(await getDatabasesPath(), "note_app.db"),
  //       onCreate: (db, version) async {
  //     await db.execute(
  //       'CREATE TABLE $dbTable(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,body TEXT, date DATE)'
  //          );

  //     //name should be similar to our model parameters name
  //   }, version: 1);
  // }

  Future<List<NoteModel>> getDbData() async {
    Database db = await this.database;
    List<Map> maps = await db.query(dbTable, orderBy: 'id ASC');
    List<NoteModel> noteList = List<NoteModel>();
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        noteList.add(NoteModel.fromMapObject(maps[i]));
      }
    }
    return noteList;
  }

  //create a function that will add a new note to our variable
  addNewNote(NoteModel note) async {
    final db = await database;
    db.insert(dbTable, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //create a function that will fetch our database and return all the element
  //inside notes table
  Future<dynamic> getNotes() async {
    final db = await database;
    var res = await db.query("notes");
    if (res.length == 0) {
      return Null;
    } else {
      var resultMap = res.toList();
      return resultMap.isNotEmpty ? resultMap : Null;
    }
  }

  //create a function to delete an item
  Future<int> deleteNote(int id) async {
    final db = await database;
    int count = await db.rawDelete("DELETE FROM notes WHERE id =?", [id]);
    return count; //return the number of raw delete
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await this.database;
    var result = await db
        .update(dbTable, note.toMap(), where: "id = ?", whereArgs: [note.id]);
    return result;
  }
}
