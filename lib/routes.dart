import 'package:portfolio_amb_app/AllScreens/historyPage.dart';
import 'package:portfolio_amb_app/AllScreens/homePage.dart';
import 'package:portfolio_amb_app/AllScreens/loginScreen.dart';
import 'package:portfolio_amb_app/AllScreens/ratingsPage.dart';
import 'package:portfolio_amb_app/AllScreens/registerScreen.dart';
import 'package:portfolio_amb_app/AllScreens/userAccount.dart';
import 'package:portfolio_amb_app/Widgets/customBottomNavBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
/*
* Created by Mujuzi Moses
*/

final Map<String, WidgetBuilder> routes = {
  RegisterScreen.screenId: (context) => RegisterScreen(),
  HomePage.screenId: (context) => HomePage(),
  LoginScreen.screenId: (context) => LoginScreen(),
  UserAccount.screenId: (context) => UserAccount(),
  CustomBottomNavBar.screenId: (context) => CustomBottomNavBar(),
  RatingsPage.screenId: (context) => RatingsPage(),
  HistoryPage.screenId: (context) => HistoryPage(),
};