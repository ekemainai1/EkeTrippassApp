import 'dart:io';

import 'package:eketrippas/data/trip_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TripDatabase {
  static final _databaseName = "TripDatabase.db";
  static final _databaseVersion = 1;
  static final table = "trip_table";

  // make this a singleton class
  TripDatabase._privateConstructor();

  static final TripDatabase instance = TripDatabase._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $table ("
        "id INTEGER PRIMARY KEY,"
        "departure TEXT,"
        "depDate TEXT,"
        "depTime TEXT,"
        "tripType TEXT,"
        "arrival TEXT,"
        "arriDate TEXT,"
        "arriTime TEXT"
        ")");
    await db.execute(
        "INSERT INTO $table (id, departure, depDate, depTime, tripType, arrival, arriDate,arriTime)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [
          1,
          "Lagos",
          "Mar 23, 2020",
          "12:45 pm",
          "Business",
          "London",
          "Apr, 30 2020",
          "2:30 pm"
        ]);

    await db.execute(
        "INSERT INTO $table (id, departure, depDate, depTime, tripType, arrival, arriDate,arriTime)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [
          2,
          "Delta",
          "Jul 20, 2020",
          "1:00 pm",
          "Health",
          "Abuja",
          "Jul, 31 2020",
          "4:35 pm"
        ]);
    await db.execute(
        "INSERT INTO $table (id, departure, depDate, depTime, tripType, arrival, arriDate,arriTime)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [
          3,
          "Delta",
          "Jul 20, 2020",
          "1:00 pm",
          "Health",
          "Abuja",
          "Jul, 31 2020",
          "4:35 pm"
        ]);
  }

  // Helper methods
  // Inserts a row in the database where each key in the Map ,is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<void> insert(TripModel tripModel) async {
    Database db = await instance.database;

    await db.insert(
      table,
      tripModel.toMap(),
    );
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.

  Future<List<TripModel>> queryAllRows() async {
    Database db = await instance.database;
    //databaseHelper has been injected in the class
    final list = await db.rawQuery("SELECT * FROM $table");
    List<TripModel> products =
        list.isNotEmpty ? list.map((c) => TripModel.fromMap(c)).toList() : [];
    int listCount = products.length;
    String tripModel = products.first.depDate;
    print('trip list: $tripModel');
    print('I am working ...');
    return products;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $table"));
    // assert(count == 2);
    print('trip count: $count');
    return count;
  }

  updateTrip(TripModel tripModel) async {
    final db = await database;
    var result = await db.update(table, tripModel.toMap(),
        where: "id = ?", whereArgs: [tripModel.id]);
    return result;
  }

  deleteTrip(int id) async {
    final db = await database;
    db.delete(table, where: "id = ?", whereArgs: [id]);
  }

  databaseClosure() async {
    await _database.close();
  }
}
