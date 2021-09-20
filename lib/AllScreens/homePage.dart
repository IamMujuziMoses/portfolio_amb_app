import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creativedata_ambulance_app/AllScreens/aboutScreen.dart';
import 'package:creativedata_ambulance_app/AllScreens/helpScreen.dart';
import 'package:creativedata_ambulance_app/AllScreens/loginScreen.dart';
import 'package:creativedata_ambulance_app/AllScreens/personalDetails.dart';
import 'package:creativedata_ambulance_app/Models/directionDetails.dart';
import 'package:creativedata_ambulance_app/Notifications/pushNotificationService.dart';
import 'package:creativedata_ambulance_app/Services/database.dart';
import 'package:creativedata_ambulance_app/Widgets/cachedImage.dart';
import 'package:creativedata_ambulance_app/Widgets/divider.dart';
import 'package:creativedata_ambulance_app/Widgets/photoViewPage.dart';
import 'package:creativedata_ambulance_app/configMaps.dart';
import 'package:creativedata_ambulance_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../sizeConfig.dart';
/*
* Created by Mujuzi Moses
*/

class HomePage extends StatefulWidget {
  static const String screenId = "homePage";

  final String uid;
  final String name;
  final String phone;
  final String email;
  final String userPic;
  const HomePage({Key key, this.uid, this.name, this.phone, this.email, this.userPic}) : super(key: key);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0.369719, 32.659309),
    zoom: 14.4746,
  );

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    locatePosition();
    getCurrentDriverInfo();
    super.initState();
  }

  Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController newGoogleMapController;
  DatabaseMethods databaseMethods = DatabaseMethods();

  DirectionDetails tripDirectionDetails;
  String driverStatus = "Offline now, Go Live";
  Color driverStatusColor = Colors.green[300];
  bool isDriverAvailable;

  var geoLocator = Geolocator();
  double leftRightPadding = 20 * SizeConfig.widthMultiplier;

  getRatings() {
    QuerySnapshot driverSnap;
    DatabaseMethods().getDriverByUid(currentDriver.uid).then((val) {
      driverSnap = val;

      if (driverSnap.docs[0].get("ratings") != null) {
        Map<dynamic, dynamic> ratingsMap = driverSnap.docs[0].get("ratings");
        int ratingPeople = int.parse(ratingsMap['people']);
        double percentage = double.parse(ratingsMap['percentage']);
        double val = 0;
        setState(() {
          val = percentage;
          people = ratingPeople;
        });

        if (val <= 5) {
          setState(() {
            starCounter = 1;
            title = "Very Bad Driver";
          });
          return;
        }
        if (val <= 25) {
          setState(() {
            starCounter = 2;
            title = "Bad Driver";
          });
          return;
        }
        if (val <= 50) {
          setState(() {
            starCounter = 3;
            title = "Good Driver";
          });
          return;
        }
        if (val <= 75) {
          setState(() {
            starCounter = 4;
            title = "Very Good Driver";
          });
          return;
        }
        if (val <= 100) {
          setState(() {
            starCounter = 5;
            title = "Excellent Driver";
          });
          return;
        }
      }
    });
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 15);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void getCurrentDriverInfo() async {
    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    await pushNotificationService.getToken();
    getRatings();
  }

  Future<bool> _onBackPressed() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit the app?"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.red[300],
          title: Text("Siro Ambulance", style: TextStyle(fontFamily: "Brand Bold"),),
        ),
        drawer: Container(
          color: Colors.white,
          width: 65 * SizeConfig.widthMultiplier,
          child: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.red[300]),
                  child: Row(
                    children: <Widget>[
                      CachedImage(
                        imageUrl: widget.userPic,
                        isRound: true,
                        radius: 70,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 2 * SizeConfig.widthMultiplier),
                      Container(
                        height: 10 * SizeConfig.heightMultiplier,
                        width: 36 * SizeConfig.widthMultiplier,
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Spacer(),
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 3 * SizeConfig.heightMultiplier,
                                  width: 36 * SizeConfig.widthMultiplier,
                                  child: Text(widget.name, style: TextStyle(
                                    fontSize: 2.3 * SizeConfig.textMultiplier,
                                    fontFamily: "Brand Bold",
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ), overflow: TextOverflow.ellipsis,),
                                ),
                                Spacer(),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 2 * SizeConfig.heightMultiplier,
                                  width: 36 * SizeConfig.widthMultiplier,
                                  child: Text(widget.email, style: TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Brand-Regular",
                                    fontSize: 1.5 * SizeConfig.textMultiplier,
                                  ), overflow: TextOverflow.ellipsis,),
                                ),
                                Spacer(),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DividerWidget(),
                SizedBox(height: 12.0,),
                //Drawer body controller
                GestureDetector(
                  onTap: () => Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => PersonalDetails(
                      name: widget.name,
                      phone: widget.phone,
                      userPic: widget.userPic,
                      email: widget.email,
                    ),
                  ),),
                  child: ListTile(
                    hoverColor: Colors.red[300],
                    leading: Container(
                      height: 5 * SizeConfig.heightMultiplier,
                      width: 10 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Icon(CupertinoIcons.person_alt),
                      ),
                    ),
                    title: Text("Profile", style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: "Brand-Regular",
                    ),),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                context, MaterialPageRoute(
                builder: (context) => HelpScreen(),
                ),),
                  child: ListTile(
                    hoverColor: Colors.red[300],
                    leading: Container(
                      height: 5 * SizeConfig.heightMultiplier,
                      width: 10 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Icon(CupertinoIcons.question_circle_fill),
                      ),),
                    title: Text("Help", style: TextStyle(
                      fontSize: 15.0,
                      fontFamily: "Brand-Regular"
                    ),),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => AboutScreen(),
                  ),),
                  child: ListTile(
                    hoverColor: Colors.red[300],
                    leading: Container(
                      height: 5 * SizeConfig.heightMultiplier,
                      width: 10 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Icon(Icons.info,
                        ),
                      ),),
                    title: Text("About", style: TextStyle(
                      fontSize: 15.0,
                      fontFamily: "Brand-Regular"
                    ),),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Geofire.removeLocation(currentDriver.uid);
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => LoginScreen()
                    ));
                  },
                  child: ListTile(
                    hoverColor: Colors.red[300],
                    leading: Container(
                      height: 5 * SizeConfig.heightMultiplier,
                      width: 10 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Icon(Icons.logout,
                        ),
                      ),),
                    title: Text("Log Out", style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.red[300],
                      fontFamily: "Brand-Regular"
                    ),),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                height: 16 * SizeConfig.heightMultiplier,
                decoration: BoxDecoration(
                  color: Colors.red[300],
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 10,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => profilePicView(
                              myName: widget.name,
                              imageUrl: widget.userPic,
                              context: context,
                              isSender: true,
                            ),
                            child: CachedImage(
                              imageUrl: widget.userPic,
                              isRound: true,
                              radius: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 5 * SizeConfig.widthMultiplier,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 0,
                                child: Container(
                                  width: 60 * SizeConfig.widthMultiplier,
                                  child: Wrap(
                                    children: [Text(widget.name, style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Brand Bold",
                                      fontSize: 3 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                              Text(
                                TimeOfDay.now().hour >= 12 && TimeOfDay.now().hour < 16
                                    ? "Good Afternoon!"
                                    : TimeOfDay.now().hour >= 16
                                    ? "Good Evening!"
                                    : "Good Morning!",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 2.2 * SizeConfig.textMultiplier,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 9 * SizeConfig.heightMultiplier,
                ),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: 75 * SizeConfig.heightMultiplier,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: GoogleMap(
                    padding: EdgeInsets.only(
                      top: 1.3 * SizeConfig.heightMultiplier,
                    ),
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: HomePage._kGooglePlex,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _googleMapController.complete(controller);
                      newGoogleMapController = controller;
                      locatePosition();
                    },
                  ),
                ),
              ),
              AnimatedPositioned(
                curve: Curves.fastOutSlowIn,
                duration: new Duration(milliseconds: 400),
                top: 10 * SizeConfig.heightMultiplier,
                left: leftRightPadding,
                right: leftRightPadding,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2 * SizeConfig.widthMultiplier,
                  ),
                  child: RaisedButton(
                    onPressed: () {
                      if (isDriverAvailable != true) {
                        makeDriverOnlineNow();
                        getLocationLiveUpdates();
                        setState(() {
                          leftRightPadding = 30 * SizeConfig.widthMultiplier;
                          driverStatusColor = Colors.red[300];
                          driverStatus = "Online Now";
                          isDriverAvailable = true;
                        });
                        displaySnackBar(message: "You are online now", context: context, label: "OK");
                      } else {
                        makeDriverOfflineNow();
                        setState(() {
                          leftRightPadding = 20 * SizeConfig.widthMultiplier;
                          driverStatusColor = Colors.green[300];
                          driverStatus = "Offline now, Go Live";
                          isDriverAvailable = false;
                        });
                        displaySnackBar(message: "You are offline now", context: context, label: "OK");
                      }
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: driverStatusColor,
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(driverStatus, style: TextStyle(
                                  fontSize: 2.5 * SizeConfig.textMultiplier,
                                  color: Colors.white,
                                  fontFamily: "Brand Bold",
                                  fontWeight: FontWeight.bold,
                                ),overflow: TextOverflow.ellipsis,),
                            ),
                            Icon(Icons.phone_android,
                              color: Colors.white,
                              size: 8 * SizeConfig.imageSizeMultiplier,
                            ),
                          ],
                        ),
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentDriver.uid, currentPosition.latitude , currentPosition.longitude);

    Map<String, dynamic> update = {"newRide": "searching"};
    await databaseMethods.updateDriverDocField(update, currentDriver.uid);
  }

  void getLocationLiveUpdates() async {
    homePageStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if (isDriverAvailable == true) {
        Geofire.setLocation(currentDriver.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  void makeDriverOfflineNow() async {
    Geofire.removeLocation(currentDriver.uid);
    await databaseMethods.deleteDriverDocField("newRide", currentDriver.uid);
  }
}

Future<dynamic> profilePicView({String imageUrl, BuildContext context, bool isSender, String chatRoomId, String myName}) {
  return showDialog(
    context: context,
    builder: (context) => Padding(
      padding: EdgeInsets.only(top: 100, left: 50, right: 50, bottom: 350),
      child: Builder(
        builder: (context) => Container(
          height: 10 * SizeConfig.heightMultiplier,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoViewPage(
                          myName: myName,
                          message: imageUrl,
                          isSender: isSender,
                          chatRoomId: chatRoomId,
                        ),
                      ));
                },
                child: CachedImage(
                  height: 33 * SizeConfig.heightMultiplier,
                  width: 90 * SizeConfig.widthMultiplier,
                  imageUrl: imageUrl,
                  radius: 10,
                  fit: BoxFit.cover,
                ),
              ),
              Spacer(),
              Row(
                children: <Widget>[
                  Spacer(),
                  Icon(Icons.message_rounded, color: Colors.red[300],),
                  SizedBox(width: 13 * SizeConfig.widthMultiplier,),
                  Icon(Icons.call_rounded, color: Colors.red[300],),
                  SizedBox(width: 13 * SizeConfig.widthMultiplier,),
                  Icon(Icons.videocam_rounded, color: Colors.red[300],),
                  SizedBox(width: 13 * SizeConfig.widthMultiplier,),
                  Icon(Icons.edit_rounded, color: Colors.red[300],),
                  Spacer(),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    ),
  );
}
