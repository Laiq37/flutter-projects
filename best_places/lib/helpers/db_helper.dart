import 'package:sqflite/sqflite.dart' as sql;

import 'package:path/path.dart' as path;

class DBhelpers {
  static Future<sql.Database> dataBase() async {
    //sql.getDataBasesPath is the method which knows the path where database is created
    final dbPath = await sql.getDatabasesPath();

    //sql.openDatabase method open the database if exist otherwise also create the database if it doesnt exist
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        //oncreate is used to creat database if not exist
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_Latitude REAL, loc_Longitude REAL, loc_Address TEXT, is_Favorite INTEGER)'); //real(same as double) is a datatype in sql
    }, version: 1);
  }

  //to use database we have to create a static method
  static Future<void> insert(
      String tableName, Map<String, dynamic> data) async {
    final db = await DBhelpers.dataBase();
    db.insert(tableName, data,
        //conflictAlgorithm repalce means it will replace the value of same id
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  //fetchingData from db
  static Future<List<Map<String, dynamic>>> getData(String tableName) async {
    final db = await DBhelpers.dataBase();
    //query methoed is used fetch data found in table
    return db.query(tableName);
  }

  static Future<void> updateFav(String tableName, String id, int fav) async {
    final db = await DBhelpers.dataBase();
    // print('at DbHelper updateFav method after opening database ');
    // int count =
    await db.rawUpdate(
        'UPDATE user_places SET is_Favorite = ? WHERE id = ?', [fav, id]);
    // print('updated: $count');
  }

  static Future<void> deleteData(String tableName, String id) async {
    final db = await DBhelpers.dataBase();

    await db.rawDelete('DELETE FROM $tableName WHERE id = ?', ['$id']);
  }
}
