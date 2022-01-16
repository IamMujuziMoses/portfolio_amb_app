import 'package:portfolio_amb_app/Models/user.dart';
import 'package:portfolio_amb_app/Services/database.dart';
import 'package:flutter/cupertino.dart';
/*
* Created by Mujuzi Moses
*/

class UserProvider with ChangeNotifier {
  User _user;

  DatabaseMethods _databaseMethods = new DatabaseMethods();

  User get getUser => _user;

  void refreshDriver() async {
    User user = await _databaseMethods.getDriverDetails();
    _user = user;
    notifyListeners();
  }
}