import 'package:creativedata_ambulance_app/Provider/userProvider.dart';
import 'package:creativedata_ambulance_app/Widgets/divider.dart';
import 'package:creativedata_ambulance_app/configMaps.dart';
import 'package:creativedata_ambulance_app/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
/*
* Created by Mujuzi Moses
*/

class RatingsPage extends StatefulWidget {
  static const String screenId = "ratingsPage";
  const RatingsPage({Key key}) : super(key: key);

  @override
  _RatingsPageState createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Ratings", style: TextStyle(
          fontFamily: "Brand Bold",
          color: Colors.red[300]
        ),),
        backgroundColor: Colors.grey[100],
      ),
      body: Container(
        color: Colors.grey[100],
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 5 * SizeConfig.heightMultiplier,),
              Text(Provider.of<UserProvider>(context).getUser.name, textAlign: TextAlign.center ,style: TextStyle(
                fontSize: 3.5 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.bold,
                fontFamily: "Brand Bold",
                color: Colors.red[300],
              ),),
              SizedBox(height: 3 * SizeConfig.widthMultiplier,),
              Container(
                width: 88 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Ratings from Riders", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Brand Bold",
                        fontSize: 3 * SizeConfig.textMultiplier,
                      ),),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                      DividerWidget(),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                      SmoothStarRating(
                        isReadOnly: true,
                        rating: starCounter,
                        color: Colors.red[300],
                        allowHalfRating: true,
                        starCount: 5,
                        size: 8 * SizeConfig.imageSizeMultiplier,
                      ),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                      DividerWidget(),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                      Text(title, style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Brand Bold",
                        fontSize: 3.5 * SizeConfig.textMultiplier,
                      ),),
                      Text("($people review(s))", style: TextStyle(
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Brand-Regular",
                        color: Colors.grey,
                      ),),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
