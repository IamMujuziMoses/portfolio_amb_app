import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:portfolio_amb_app/AllScreens/loginScreen.dart';
import 'package:portfolio_amb_app/Provider/appData.dart';
import 'package:portfolio_amb_app/Provider/userProvider.dart';
import 'package:portfolio_amb_app/Services/auth.dart';
import 'package:portfolio_amb_app/Services/database.dart';
import 'package:portfolio_amb_app/Widgets/customBottomNavBar.dart';
import 'package:portfolio_amb_app/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:overlay_support/overlay_support.dart';
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
AuthMethods authMethods = new AuthMethods();
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
      child: OverlaySupport.global(
        child: new MaterialApp(
          title: "Siro Ambulance App",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(

            canvasColor: Colors.grey[100],
            primarySwatch: Colors.grey,
            primaryIconTheme: IconThemeData(color: Color(0xFFa81845)),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: firebaseAuth.currentUser  == null ? LoginScreen() : CustomBottomNavBar(),
          routes: routes,
        ),
      ),
    );
  }
}
