import 'package:eketrippas/data/trip_model.dart';
import 'package:eketrippas/provider/trip_notifier.dart';
import 'package:eketrippas/provider/trip_shared_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_screen/responsive_screen.dart';

class UpdateTripScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Create a trip",
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<TripNotifier>(
              create: (context) => TripNotifier()),
          ChangeNotifierProvider<TripSharedNotifier>(
              create: (context) => TripSharedNotifier()),
        ],
        child: Scaffold(
          body: UpdateTripHome(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add_list_screen');
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}

class UpdateTripHome extends StatelessWidget {
  // Text fields controllers
  TextEditingController departController = TextEditingController();
  TextEditingController depDateController = TextEditingController();
  TextEditingController destController = TextEditingController();
  TextEditingController destDateController = TextEditingController();
  TextEditingController departTimeController = TextEditingController();
  TextEditingController destTimeController = TextEditingController();

  final String title;
  final TextStyle textStyle = new TextStyle(color: Colors.grey, fontSize: 20.0);
  final tripType = ["Business", "Education", "Health", "Vacation"];
  String dropdownValue = "Business";
  String result = ' ';

  UpdateTripHome({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wp = Screen(context).wp;
    final hp = Screen(context).hp;
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Create a trip",
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<TripNotifier>(builder: (context, trip, child) {
        return FutureBuilder(
            future: trip.loadTripType(),
            builder: (BuildContext context, AsyncSnapshot tripSnapshot) {

              return Stack(fit: StackFit.loose, children: <Widget>[
                Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                    Widget>[
                  _buildTextDeparture(),
                  _buildTextDepDate(),
                  _buildTextDest(),
                  _buildTextDestDate(),
                  _buildDropDownMenu(trip),
                  Consumer<TripSharedNotifier>(
                      builder: (context, upModel, child) {
                    return FutureBuilder(
                      future: upModel.loadDeleteId(),
                      builder: (BuildContext context, AsyncSnapshot tripSnap) {
                        if (tripSnap.hasData) {
                          return RaisedButton(
                            child: new Container(
                              alignment: Alignment.center,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                color: Colors.blueAccent,
                                border: new Border.all(
                                    color: Colors.white, width: 0.0),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: new Center(
                                child: new Text(
                                  'Update Trip',
                                  style: new TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                              ),
                            ),
                            onPressed: () {
                              _submittedTripToDatabase(trip,
                                  tripSnapshot.data.toString(), tripSnap.data);
                              trip.storeTripType(tripSnapshot.data.toString());
                            },
                          );
                        } else {
                          return Text(' ');
                        }
                      },
                    );
                  }),
                ]),
              ]);
            });
      }),
    );
  }

  Widget _buildTextDeparture() {
    return new Container(
      height: 50.0,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          new Flexible(
            child: new TextField(
                decoration: InputDecoration(
                    hintStyle: textStyle, hintText: 'Enter Departure'),
                controller: departController,
                onSubmitted: (String str) {
                  result = str;
                }),
          ), //new
        ],
      ),
    );
  }

  Widget _buildTextDepDate() {
    return new Container(
      height: 50.0,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(children: <Widget>[
        new Flexible(
          child: new TextField(
              decoration:
                  InputDecoration(hintStyle: textStyle, hintText: 'Enter Date'),
              controller: depDateController,
              onSubmitted: (String str) {
                result = str;
              }),
        ),
        new Flexible(
          child: new TextField(
              decoration:
                  InputDecoration(hintStyle: textStyle, hintText: 'Enter Time'),
              controller: departTimeController,
              onSubmitted: (String str) {
                result = str;
              }),
        ),
      ]), //new
    );
  }

  Widget _buildTextDest() {
    return new Container(
      height: 50.0,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(children: <Widget>[
        new Flexible(
          child: new TextField(
              decoration: InputDecoration(
                  hintStyle: textStyle, hintText: 'Enter destination'),
              controller: destController,
              onSubmitted: (String str) {
                result = str;
              }),
        ),
      ]), //new
    );
  }

  Widget _buildTextDestDate() {
    return new Container(
      height: 50.0,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(children: <Widget>[
        new Flexible(
          child: new TextField(
              decoration:
                  InputDecoration(hintStyle: textStyle, hintText: 'Enter Date'),
              controller: destDateController,
              onSubmitted: (String str) {
                result = str;
              }),
        ),
        new Flexible(
          child: new TextField(
              decoration:
                  InputDecoration(hintStyle: textStyle, hintText: 'Enter Time'),
              controller: destTimeController,
              onSubmitted: (String str) {
                result = str;
              }),
        ),
      ]), //new
    );
  }

  Widget _buildDropDownMenu(TripNotifier tripNotifier) {
    return new Container(
      height: 50.0,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(children: <Widget>[
        new Flexible(
          child: Text(
            "Trip Type",
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Spacer(),
        new Flexible(
          child: DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.navigation),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              dropdownValue = tripNotifier.getDropDownButtonState(newValue);
              tripNotifier.storeTripType(dropdownValue);
            },
            items: <String>["Business", "Education", "Health", "Vacation"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }

  TripModel tripData(TripNotifier tripNotifier, String string, int id) {
    // Text retrieve from user for storage
    String departure;
    String depDate;
    String depTime;
    String destination;
    String destDate;
    String destTime;
    String tripTypeItem;
    int updateId;
    tripTypeItem = string;
    updateId = id;

    departure = departController.text;
    depDate = depDateController.text;
    depTime = departTimeController.text;
    destination = destController.text;
    destDate = destDateController.text;
    destTime = destTimeController.text;

    final dataList = new TripModel(
        id: updateId,
        departure: departure,
        depDate: depDate,
        depTime: depTime,
        tripType: tripTypeItem,
        arrival: destination,
        arriDate: destDate,
        arriTime: destTime);
    return dataList;
  }

  void _handTextSubmitted() {
    departController.clear();
    destDateController.clear();
    depDateController.clear();
    departTimeController.clear();
    destDateController.clear();
    destTimeController.clear();
    destController.clear();
  }

  void _submittedTripToDatabase(
      TripNotifier tripNotifier, String string, int id) {
    if (departTimeController.text.isEmpty ||
        depDateController.text.isEmpty ||
        departTimeController.text.isEmpty ||
        destController.text.isEmpty ||
        destDateController.text.isEmpty ||
        destTimeController.text.isEmpty == null) {
      print('Please insert missing info');
    } else {
      tripNotifier.updateEachTrip(tripData(tripNotifier, string, id));
      _handTextSubmitted();
    }
  }
}
