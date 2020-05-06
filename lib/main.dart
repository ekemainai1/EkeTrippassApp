import 'package:eketrippas/provider/trip_notifier.dart';
import 'package:eketrippas/provider/trip_shared_notifier.dart';
import 'package:eketrippas/ui/add_trip_screen.dart';
import 'package:eketrippas/ui/trip_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EkeTrippasApp',
      home: EkeTripAppMain(),
      initialRoute: '/',
      routes: {
        '/trip_list_screen': (context) => TripListScreen(),
        '/add_list_screen': (context) => AddTripScreen(),
      },
    ));

class EkeTripAppMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TripNotifier>(
            create: (context) => TripNotifier()),
        ChangeNotifierProvider<TripSharedNotifier>(
            create: (context) => TripSharedNotifier()),
      ],
      child: Scaffold(
        body: TripListScreen(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add_list_screen');
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
