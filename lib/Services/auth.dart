import 'package:portfolio_amb_app/AllScreens/loginScreen.dart';
import 'package:portfolio_amb_app/Services/database.dart';
import 'package:portfolio_amb_app/Widgets/progressDialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
/*
* Created by Mujuzi Moses
*/

class AuthMethods {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Future signInWithEmailAndPassword(BuildContext context, String email, String password) async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Logging you in, Please wait",);
        });

    final User firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(email: email.trim(), password: password.trim())
        .catchError((errMsg) {
    Navigator.pop(context);
    displayToastMessage("Error: " + errMsg, context);
    })).user;
    return firebaseUser.uid;
  }

  Future signUpWithEmailAndPassword(BuildContext context, String email, String password) async {

    final User firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(email: email.trim(), password: password.trim())
        .catchError((errMsg) {
      Navigator.pop(context);
      print(errMsg);
      displayToastMessage("Error: " + errMsg, context);
    })).user;

    return firebaseUser.uid;
  }
}
