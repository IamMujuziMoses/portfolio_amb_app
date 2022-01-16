import 'dart:io';

import 'package:portfolio_amb_app/Widgets/cachedImage.dart';
import 'package:portfolio_amb_app/AllScreens/loginScreen.dart';
import 'package:portfolio_amb_app/AllScreens/registerScreen.dart';
import 'package:portfolio_amb_app/Services/auth.dart';
import 'package:portfolio_amb_app/Services/database.dart';
import 'package:portfolio_amb_app/Services/helperFunctions.dart';
import 'package:portfolio_amb_app/Utilities/permissions.dart';
import 'package:portfolio_amb_app/Utilities/utils.dart';
import 'package:portfolio_amb_app/Widgets/customBottomNavBar.dart';
import 'package:portfolio_amb_app/Widgets/progressDialog.dart';
import 'package:portfolio_amb_app/constants.dart';
import 'package:portfolio_amb_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:image_picker/image_picker.dart';
/*
* Created by Mujuzi Moses
*/

class DriverRegistration extends StatefulWidget {
  static const String screenId = "driverRegistrationScreen";

  final String name;
  final String email;
  final String phone;
  final String password;
  final dynamic val;
  const DriverRegistration({Key key, this.name, this.email, this.phone, this.password, this.val}) : super(key: key);

  @override
  _DriverRegistrationState createState() => _DriverRegistrationState();
}

class _DriverRegistrationState extends State<DriverRegistration> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController hospitalTEC = TextEditingController();
  TextEditingController licencePlateTEC = TextEditingController();
  String profilePhoto;

  DropDownList _yearsList = new DropDownList(
    listItems: ["1-2 years", "3 -5 years", "5-10 years", "10+ years"],
    placeholder: "Years Of Experience",
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        titleSpacing: 0,
        title: Text("Driver's Registration", style: TextStyle(
          fontFamily: "Brand Bold",
          color: Color(0xFFa81845),
        ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
              Text("Driver's Information", style: TextStyle(
                fontSize: 6 * SizeConfig.imageSizeMultiplier,
                fontFamily: "Brand Bold",),
                textAlign: TextAlign.center,
              ),
              Text("Fill in every field please", style: TextStyle(
                fontSize: 3 * SizeConfig.imageSizeMultiplier,),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
              Center(
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        height: 10 * SizeConfig.heightMultiplier,
                        width: 20 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white,
                          border: Border.all(color: Color(0xFFa81845), style: BorderStyle.solid, width: 2),
                        ),
                        child: profilePhoto == null
                            ? Image.asset("images/user_icon.png")
                            : CachedImage(
                          imageUrl: profilePhoto,
                          isRound: true,
                          radius: 10,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 6 * SizeConfig.heightMultiplier,
                      width: 55 * SizeConfig.widthMultiplier,
                      child: Row(
                        children: <Widget>[
                          Text("Select Your Profile Picture:", style: TextStyle(
                              fontSize: 3.5 * SizeConfig.imageSizeMultiplier,
                              fontWeight: FontWeight.w500
                          ),),
                          Spacer(),
                          Container(
                            height: 5 * SizeConfig.heightMultiplier,
                            width: 10 * SizeConfig.widthMultiplier,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: FocusedMenuHolder(
                              blurSize: 0,
                              //blurBackgroundColor: Colors.transparent,
                              duration: Duration(milliseconds: 500),
                              menuWidth: MediaQuery.of(context).size.width * 0.3,
                              menuItemExtent: 40,
                              onPressed: () {
                                displayToastMessage("Tap & Hold to make selection", context);
                              },
                              menuItems: <FocusedMenuItem>[
                                FocusedMenuItem(title: Text("Gallery", style: TextStyle(
                                    color: Color(0xFFa81845), fontWeight: FontWeight.w500),),
                                  onPressed: () async =>
                                  await Permissions.cameraAndMicrophonePermissionsGranted() ?
                                  pickImage(
                                      source: ImageSource.gallery,
                                      context: context,
                                      databaseMethods: databaseMethods).then((val) {
                                    setState(() {
                                      profilePhoto = val;
                                    });
                                  }) : {},
                                  trailingIcon: Icon(Icons.photo_library_outlined, color: Color(0xFFa81845),),
                                ),
                                FocusedMenuItem(title: Text("Capture", style: TextStyle(
                                    color: Color(0xFFa81845), fontWeight: FontWeight.w500),),
                                  onPressed: () async =>
                                  await Permissions.cameraAndMicrophonePermissionsGranted() ?
                                  pickImage(
                                      source: ImageSource.camera,
                                      context: context,
                                      databaseMethods: databaseMethods).then((val) {
                                    setState(() {
                                      profilePhoto = val;
                                    });
                                  }) : {},
                                  trailingIcon: Icon(Icons.camera, color: Color(0xFFa81845),),
                                ),
                              ],
                              child: Icon(Icons.camera_alt_outlined, color: Color(0xFFa81845),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: hospitalTEC,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Hospital's Name",
                        labelStyle: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 1.5 * SizeConfig.textMultiplier,
                        ),
                      ),
                      style: TextStyle(fontSize: 2 * SizeConfig.textMultiplier),
                    ),
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: licencePlateTEC,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Ambulance Licence Plate",
                        labelStyle: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 1.5 * SizeConfig.textMultiplier,
                        ),
                      ),
                      style: TextStyle(fontSize: 2 * SizeConfig.textMultiplier),
                    ),
                    SizedBox(height: 1.0,),
                    _yearsList,
                    SizedBox(height: 2.5 * SizeConfig.heightMultiplier,),
                    RaisedButton(
                      clipBehavior: Clip.hardEdge,
                      padding: EdgeInsets.zero,
                      elevation: 8,
                      textColor: Colors.white,
                      child: Container(
                        height: 6.5 * SizeConfig.heightMultiplier,
                        width: 100 * SizeConfig.widthMultiplier,
                        decoration: BoxDecoration(
                          gradient: kPrimaryGradientColor,
                        ),
                        child: Center(
                          child: Text("Submit", style: TextStyle(
                            fontSize: 2.5 * SizeConfig.textMultiplier,
                            fontFamily: "Brand Bold",
                          ),),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(14),
                      ),
                      onPressed: () {
                        String years = _yearsList.selectedValue;
                        if (hospitalTEC.text.isEmpty) {
                          displayToastMessage("Provide Your Hospital", context);
                        } else if (years == "") {
                          displayToastMessage("Provide Your Years of Experience", context);
                        } else if (licencePlateTEC.text.isEmpty) {
                          displayToastMessage("Provide Ambulance Licence Plate", context);
                        } else {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return ProgressDialog(message: "Signing you up, Please wait",);
                              });
                          Map<String, dynamic> userDataMap = {
                            "uid" : widget.val,
                            "name": widget.name,
                            "email": widget.email,
                            "phone": widget.phone,
                            "years": years,
                            "licence_plate": licencePlateTEC.text.trim(),
                            "hospital": hospitalTEC.text.trim(),
                            "username" : Utils.getUsername(widget.email),
                            "profile_photo": profilePhoto,
                            "history": null,
                            "state": null,
                            "ratings": null,
                            "status": null,
                          };
                          databaseMethods.uploadDriverInfo(userDataMap);
                          HelperFunctions.saveUserLoggedInSharedPref(true);
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => CustomBottomNavBar()
                          ));
                          displayToastMessage("New driver account created Successfully", context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
