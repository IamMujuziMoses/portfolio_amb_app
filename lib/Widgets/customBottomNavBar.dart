import 'dart:async';

import 'package:portfolio_amb_app/AllScreens/historyPage.dart';
import 'package:portfolio_amb_app/AllScreens/homePage.dart';
import 'package:portfolio_amb_app/AllScreens/ratingsPage.dart';
import 'package:portfolio_amb_app/AllScreens/userAccount.dart';
import 'package:portfolio_amb_app/Assistants/assistantMethods.dart';
import 'package:portfolio_amb_app/Provider/userProvider.dart';
import 'package:portfolio_amb_app/constants.dart';
import 'package:portfolio_amb_app/main.dart';
import 'package:portfolio_amb_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
/*
* Created by Mujuzi Moses
*/

class CustomBottomNavBar extends StatefulWidget {
  static const String screenId = "customBottomNavBar";
  const CustomBottomNavBar({Key key}) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {

  int _currentIndex = 0;
  UserProvider userProvider;
  String name = "";
  String phone = "";
  String userPic = "";
  String email = "";
  String hospital = "";
  StreamSubscription subscription;

  @override
  void initState() {
    getUserInfo();
    super.initState();

    subscription = InternetConnectionChecker().onStatusChange.listen((status) {
      bool hasInternet = status == InternetConnectionStatus.connected;

      if (hasInternet == true) {
        showSimpleNotification(
          Text("Connected", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Colors.white,
          ),),
          background: Color(0xFFa81845),
          elevation: 0,
        );
      } else {
        showSimpleNotification(
          Text("No Internet Connection", style: TextStyle(
            fontFamily: "Brand Bold",
            color: Colors.white,
          ),),
          background: Color(0xFFa81845),
          elevation: 0,
        );
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void getUserInfo() async {
    AssistantMethods.retrieveHistoryInfo(context);
    Constants.myName = await databaseMethods.getName();
    databaseMethods.getPhone().then((val) {
      setState(() {
        phone = val;
      });
    });
    databaseMethods.getHospital().then((val) {
      setState(() {
        hospital = val;
      });
    });
    databaseMethods.getName().then((val) {
      setState(() {
        name = val;
      });
    });
    databaseMethods.getEmail().then((val) {
      setState(() {
        email = val;
      });
    });
    databaseMethods.getProfilePhoto().then((val) {
      setState(() {
        userPic = val;
      });
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshDriver();
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> driverChildren = [
      HomePage(uid: currentDriver.uid, name: name, email: email, phone: phone, userPic: userPic,),
      HistoryPage(),
      RatingsPage(),
      UserAccount(name: name, email: email, userPic: userPic, phone: phone),
    ];
    SizeConfig().init(context);
    return bottomNavBar(child: driverChildren, index: _currentIndex);
  }

  Widget bottomNavBar({List<Widget> child, int index}) {
    return Scaffold(
        body: IndexedStack(
          children: child,
          index: index,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey[100],
          onTap: onTappedBar,
          elevation: 0,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          selectedLabelStyle: TextStyle(
            fontFamily: "Brand Bold",
            fontWeight: FontWeight.w500,
          ),
          selectedItemColor: Color(0xFFa81845),
          currentIndex: index,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house, color: Color(0xFFa81845),),
              label: "Home",
              activeIcon: selectedIcon(CupertinoIcons.house_fill),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history, color: Color(0xFFa81845),),
              label: "History",
              activeIcon: selectedIcon(Icons.history),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.star, color: Color(0xFFa81845)),
              label: "Ratings",
              activeIcon: selectedIcon(CupertinoIcons.star_fill),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_circle, color: Color(0xFFa81845)),
              label: "Profile",
              activeIcon: selectedIcon(CupertinoIcons.person_circle_fill),
            ),
          ],
        ),
      );
  }

  Widget selectedIcon(IconData icon) {
    return Container(
      height: 3.5 * SizeConfig.heightMultiplier,
      width: 28 * SizeConfig.widthMultiplier,
      decoration: BoxDecoration(
        gradient: kPrimaryGradientColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}