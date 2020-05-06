import 'package:eketrippas/data/trip_database.dart';
import 'package:eketrippas/data/trip_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripNotifier extends ChangeNotifier {
  // reference to our single class that manages the database
  final dbHelper = TripDatabase.instance;
  // Methods for database
  void insertEachTrip(TripModel tripModel) async {
    // row to insert
    final id = await dbHelper.insert(tripModel);
    notifyListeners();
  }

  Future<void> insertTrip(TripModel tripModel) async {
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await dbHelper.insert(tripModel);
    notifyListeners();
  }

  Future<List<TripModel>> queryAllTrips() async {
    var allRows = await dbHelper.queryAllRows();
    String tripModel = allRows.first.depDate;
    print('TRIP IS WORKING: $tripModel');
    notifyListeners();
    return allRows;
  }

  Future<void> updateEachTrip(TripModel tripModel) async {
    final rowsAffected = await dbHelper.updateTrip(tripModel);
    notifyListeners();
  }

  Future<void> deleteEachTrip(int id) async {
    // Assuming that the number of rows is the id for the last row.
    final rowsDeleted = await dbHelper.deleteTrip(id);
    notifyListeners();
  }

  // Get number of trips
  Future<int> getTripCount() async {
    int count;
    final result = await dbHelper.queryRowCount();
    count = result;
    notifyListeners();
    return count;
  }

  // DropDownButton state management
  String getDropDownButtonState(String dropValue) {
    String tripType = "Business";
    List<String> tripTypes = ["Business", "Education", "Health", "Vacation"];
    if (dropValue == tripTypes[2].toString()) {
      tripType = tripTypes[2].toString();
    } else if (dropValue == tripTypes[3].toString()) {
      tripType = tripTypes[3].toString();
    } else if (dropValue == tripTypes[4].toString()) {
      tripType = tripTypes[4].toString();
    } else {
      tripType = tripTypes[1].toString();
    }
    notifyListeners();
    return tripType;
  }

  // Store selected trip type in sharedPreferences
  Future<bool> storeTripType(String value) async {
    // obtain shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();
    return await prefs.setString("count", value);
  }

  Future<String> loadTripType() async {
    // Try reading data from the counter key. If it doesn't exist, return 0.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var type = prefs.getString("count") ?? "Business";
    print('Shared Value: $type');
    notifyListeners();
    return type;
  }

  // Store selected trip type in sharedPreferences
  Future<void> storeDeleteId(int value) async {
    // obtain shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("delete", value);
    notifyListeners();
  }
}
