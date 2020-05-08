import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripSharedNotifier extends ChangeNotifier {
  Future<int> loadDeleteId() async {
    // Try reading data from the counter key. If it doesn't exist, return 0.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("delete") ?? 1;
    print('Shared Delete Id: $id');
    notifyListeners();
    return id;
  }
}
