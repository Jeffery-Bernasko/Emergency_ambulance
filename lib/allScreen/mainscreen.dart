import 'dart:async';

import 'package:emergency_ambulance/Assistants/assistantMethod.dart';
import 'package:emergency_ambulance/allScreen/searchScreen.dart';
import 'package:emergency_ambulance/allwidgets/progressDialog.dart';
import 'package:emergency_ambulance/dataHandler/appData.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Position currentPosition;
  var geolocator = Geolocator();

  double bottomPaddingOfMap = 0;

  //Function To Get Current User Position
  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    print(currentPosition);
    print(position);
    LatLng latLngPosition =
        LatLng(currentPosition.latitude, currentPosition.longitude);

    print(latLngPosition);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(
        currentPosition, context);
    print("This is your Address :: " + address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.673175, -1.565423),
    zoom: 10,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Main Screen'),
      ),
      drawer: Container(
        width: 255.0,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            children: [
              //Drawer Header
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset("images/user_icon.png",
                          height: 65.0, width: 65.0),
                      SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Profile Name",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          Text(
                            'View Profile',
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                color: Colors.black54,
                thickness: 1.0,
              ),
              SizedBox(
                height: 12.0,
              ),
              // Drawer Body Controllers
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  "Ride History",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "View Profile",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  "About",
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottomPaddingOfMap = 300.0;
              });

              // Call function to get the current Position
              locatePosition();
            },
          ),

          // Button For Drawer
          Positioned(
            top: 45.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 6.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7))
                    ]),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          //Changes Might Occur in Future

          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18.0),
                  topLeft: Radius.circular(18.0),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white,
                      blurRadius: 14.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7))
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      "Hi There",
                      style: TextStyle(fontSize: 12.0),
                    ),
                    Text(
                      "Click Here for An Emergency Request",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    // Emergency Battery should be somewhere Here
                    Center(
                      child: MaterialButton(
                        textColor: Colors.white,
                        color: Colors.redAccent,
                        child: Text('Emergency'),
                        height: 50.0,
                        onPressed: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) => SearchScreen()));

                          if (res == "obtainDirection") {
                            await getPlaceDirection();
                          }
                        },
                      ),
                    ),
                    // GestureDetector(
                    // onTap: () {
                    // Navigator.push(
                    //   context,
                    // MaterialPageRoute(
                    //   builder: (context) => SearchScreen()));
                    //},
                    /* child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7))
                          ],
                        ),*/
                    // child: Padding(
                    // padding: const EdgeInsets.all(8.0),
                    //child: Row(
                    //children: [
                    /* Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text('Search Drop Off')*/
                    //],
                    //),
                    //),
                    //  ),

                    SizedBox(
                      height: 20.0,
                    ),
                    /* Divider(
                      height: 1.0,
                      color: Colors.black54,
                      thickness: 1.0,
                    ),*/
                    // Home And Work Later
                    //Row()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Please Wait..",
            ));

    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    Navigator.pop(context);

    print("This is encoded:: ");
    print(details.encodedPoints);
  }
}
