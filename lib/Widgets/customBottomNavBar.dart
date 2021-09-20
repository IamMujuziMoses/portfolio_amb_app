import 'package:creativedata_ambulance_app/AllScreens/historyPage.dart';
import 'package:creativedata_ambulance_app/AllScreens/homePage.dart';
import 'package:creativedata_ambulance_app/AllScreens/ratingsPage.dart';
import 'package:creativedata_ambulance_app/AllScreens/userAccount.dart';
import 'package:creativedata_ambulance_app/Assistants/assistantMethods.dart';
import 'package:creativedata_ambulance_app/Provider/userProvider.dart';
import 'package:creativedata_ambulance_app/Services/database.dart';
import 'package:creativedata_ambulance_app/constants.dart';
import 'package:creativedata_ambulance_app/main.dart';
import 'package:creativedata_ambulance_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  DatabaseMethods databaseMethods = DatabaseMethods();
  String name = "";
  String phone = "";
  String userPic = "";
  String email = "";
  String hospital = "";

  @override
  void initState() {
    getUserInfo();
    super.initState();
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
        body: child[index],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.red[300],
          onTap: onTappedBar,
          elevation: 8,
          showUnselectedLabels: false,
          showSelectedLabels: true,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
          ),
          selectedItemColor: Colors.white,
          currentIndex: index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.house, color: Colors.white,),
              label: "Home",
              activeIcon: selectedIcon(CupertinoIcons.house_fill),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history, color: Colors.white,),
              label: "History",
              activeIcon: selectedIcon(Icons.history),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.star, color: Colors.white),
              label: "Ratings",
              activeIcon: selectedIcon(CupertinoIcons.star_fill),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_circle, color: Colors.white),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.red[300],
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