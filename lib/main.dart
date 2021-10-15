import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:creativedata_ambulance_app/AllScreens/loginScreen.dart';
import 'package:creativedata_ambulance_app/Provider/appData.dart';
import 'package:creativedata_ambulance_app/Provider/userProvider.dart';
import 'package:creativedata_ambulance_app/Services/database.dart';
import 'package:creativedata_ambulance_app/Widgets/customBottomNavBar.dart';
import 'package:creativedata_ambulance_app/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
/*
* Created by Mujuzi Moses
*/

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}
AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
Position currentPosition;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User currentDriver = firebaseAuth.currentUser;
DatabaseMethods databaseMethods = DatabaseMethods();
StreamSubscription<Position> homePageStreamSubscription;
StreamSubscription<Position> rideStreamSubscription;

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey[100],
      //systemNavigationBarColor: Colors.red[300],
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return new MultiProvider(
      providers: [
        ChangeNotifierProvider<AppData>(create: (context) => AppData(),),
        ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider(),),
      ],
      child: new MaterialApp(
        title: "Siro Ambulance App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryIconTheme: IconThemeData(color: Colors.red[300]),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: firebaseAuth.currentUser  == null ? LoginScreen() : CustomBottomNavBar(),
        routes: routes,
      ),
    );
  }
}
