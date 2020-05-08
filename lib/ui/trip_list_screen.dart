import 'package:eketrippas/data/trip_model.dart';
import 'package:eketrippas/provider/trip_notifier.dart';
import 'package:eketrippas/provider/trip_shared_notifier.dart';
import 'package:eketrippas/ui/update_trip_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:getflutter/components/floating_widget/gf_floating_widget.dart';
import 'package:getflutter/components/toast/gf_toast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'package:simple_permissions/simple_permissions.dart';

class TripListScreen extends StatelessWidget {
  final TextStyle textStyle = new TextStyle(color: Colors.grey, fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    requestPermissionCases();

    final wp = Screen(context).wp; //specify wp
    final hp = Screen(context).hp; //specify hp
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Hello, Arthor",
      home: Scaffold(
        body: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            Positioned.fill(
              top: 50,
              child: Consumer<TripNotifier>(builder: (context, trip, child) {
                return FutureBuilder(
                  future: trip.getTripCount(),
                  builder: (BuildContext context, AsyncSnapshot snapShot) {
                    if (snapShot.hasData) {
                      return _buildListHeader(snapShot.data.toString());
                    } else if (snapShot.hasError) {
                      return CircularProgressIndicator();
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
              }),
            ),
            Positioned.fill(
              top: 100,
              child: Container(
                height: 30.0,
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Create your trip with us",
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            ),
            Positioned.fill(
              top: 140,
              child: Consumer<TripNotifier>(
                builder: (context, trip, child) {
                  return FutureBuilder(
                    future: trip.queryAllTrips(),
                    builder:
                        (BuildContext context, AsyncSnapshot tripSnapshot) {
                      if (tripSnapshot.hasData) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(6),
                          itemCount: tripSnapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            String stringType;
                            TripModel strip = tripSnapshot.data[index];
                            stringType = strip.tripType;
                            int id;
                            TripModel stripMat = tripSnapshot.data[index];
                            id = stripMat.id;
                            print("Am I Holding Value: $id");
                            return GestureDetector(
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Consumer<TripSharedNotifier>(
                                          builder: (context, myModel, child) {
                                        return FutureBuilder(
                                            future: myModel.loadDeleteId(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot tripSnap) {
                                              if (tripSnap.hasData) {
                                                return _buildAllListItem(
                                                    context,
                                                    trip,
                                                    tripSnapshot.data[index],
                                                    stringType,
                                                    myModel,
                                                    tripSnap.data,
                                                    id);
                                              } else {
                                                return Text(
                                                    "Awaiting result ...");
                                              }
                                            });
                                      }),
                                    ),
                                    Divider(
                                      height: 25,
                                      thickness: 15,
                                      color: Colors.grey.withAlpha(10),
                                      indent: 16,
                                      endIndent: 16,
                                    )
                                  ],
                                ),
                                onTap: () {
                                  trip.storeDeleteId(
                                      tripSnapshot.data[index].id);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(index.toString())));
                                });
                          },
                        );
                      } else if (tripSnapshot.hasError) {
                        return Container(
                          alignment: AlignmentDirectional.center,
                          child: GFFloatingWidget(
                            horizontalPosition: 20.0,
                            verticalPosition: 10.0,
                            child: GFToast(
                              text: 'Database query failed',
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          alignment: AlignmentDirectional.center,
                          child: GFFloatingWidget(
                            horizontalPosition: 20.0,
                            verticalPosition: 10.0,
                            child: GFToast(
                              text: 'Database query is empty',
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListHeader(String count) {
    return new Container(
      height: 50.0,
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Text(
              "Hello, Arthor",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacer(),
          RaisedButton(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.blue)),
            onPressed: () {},
            child: Text(
              count + ' Trips',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListDepDest(TripModel tripModel) {
    return new Container(
      height: 50.0,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            child: Text(
              tripModel.departure,
              style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Image.asset("assets/images/plane.png"),
          Flexible(
            child: Text(
              tripModel.arrival,
              style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListDepDestDate(TripModel tripModel) {
    return new Container(
      height: 50.0,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            child: Text(
              tripModel.depDate,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              tripModel.arriDate,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListDepDestTime(TripModel tripModel) {
    return new Container(
      height: 50.0,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            child: Text(
              tripModel.depTime,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              tripModel.arriTime,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListDepDestMenu(
      context,
      TripNotifier tripNotifier,
      TripModel tripModel,
      String string,
      TripSharedNotifier tripSharedNotifier,
      int id,
      int index) {
    return new Container(
      height: 50.0,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            child: FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.blueAccent,
              onPressed: () {},
              child: Text(
                string,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _listTripMenu(context, tripNotifier, tripModel, id, index);
              tripNotifier.storeDeleteId(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAllListItem(
      BuildContext context,
      TripNotifier tripNotifier,
      TripModel tripModel,
      String string,
      TripSharedNotifier tripSharedNotifier,
      int id,
      int index) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[100],
            blurRadius: 25.0, // soften the shadow
            spreadRadius: 5.0, //extend the shadow
            offset: Offset(
              5.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildListDepDest(tripModel),
          _buildListDepDestDate(tripModel),
          _buildListDepDestTime(tripModel),
          _buildListDepDestMenu(context, tripNotifier, tripModel, string,
              tripSharedNotifier, id, index)
        ],
      ),
    );
  }

  requestPermissionCases() async {
    Permission readPermission = Permission.ReadExternalStorage;
    Permission writePermission = Permission.WriteExternalStorage;
    Permission cameraPermission = Permission.Camera;
    bool camStatus = await SimplePermissions.checkPermission(cameraPermission);
    bool writeStatus = await SimplePermissions.checkPermission(writePermission);
    bool readStatus = await SimplePermissions.checkPermission(readPermission);
    final resCam = await SimplePermissions.requestPermission(cameraPermission);
    final resWrite = await SimplePermissions.requestPermission(writePermission);
    final resRead = await SimplePermissions.requestPermission(readPermission);

    print("permission request result is " + resCam.toString());
    print("permission request result is " + resWrite.toString());
    print("permission request result is " + resRead.toString());
  }

  Future<void> _listTripMenu(context, TripNotifier tripNotifier,
      TripModel tripModel, int id, int index) async {
    return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              actions: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  height: 200.0,
                  width: 300.0,
                  child: Column(
                    children: <Widget>[
                      Align(
                        // These values are based on trial & error method
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          tripNotifier.deleteEachTrip(id);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                        indent: 5,
                        endIndent: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UpdateTripScreen()));
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Update",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]);
        });
  }
}
