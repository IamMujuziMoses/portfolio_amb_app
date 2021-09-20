import 'package:creativedata_ambulance_app/Widgets/divider.dart';
import 'package:creativedata_ambulance_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text("Help", style: TextStyle(fontFamily: "Brand Bold"),),
          backgroundColor: Colors.red[300],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey[100],
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Row(
                  children: <Widget>[
                    Text("WE ARE HAPPY TO HELP", style: TextStyle(
                      fontSize: 2 * SizeConfig.textMultiplier,
                      fontFamily: "Brand Bold",
                      fontWeight: FontWeight.w900,
                      color: Colors.black54,
                    ),),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Container(
                  height: 28 * SizeConfig.heightMultiplier,
                  width: 95 * SizeConfig.widthMultiplier,
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
                    padding: EdgeInsets.all(4),
                    child: Column(
                      children: <Widget>[
                        _tiles(
                            onTap: () {},
                            icon: CupertinoIcons.phone_circle,
                            message: "Call Help Line",
                            color: Colors.red[300]
                        ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        DividerWidget(),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        _tiles(
                            onTap: () {},
                            icon: CupertinoIcons.exclamationmark_triangle,
                            message: "Report a Problem",
                            color: Colors.red[300]
                        ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        DividerWidget(),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        _tiles(
                            onTap: () {},
                            icon: CupertinoIcons.ellipses_bubble,
                            message: "Send Feedback",
                            color: Colors.red[300]
                        ),
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

  Widget _tiles({IconData icon, String message, Color color, Function onTap}) {
    return Material(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.red[200],
        highlightColor: Colors.grey.withOpacity(0.1),
        radius: 800,
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 7 * SizeConfig.heightMultiplier,
          width: 93 * SizeConfig.widthMultiplier,
          child: Row(
            children: <Widget>[
              Icon(icon,
                color: color,
                size: 6 * SizeConfig.imageSizeMultiplier,
              ),
              SizedBox(width: 3 * SizeConfig.widthMultiplier,),
              Text(message, style: TextStyle(
                fontWeight: FontWeight.w400,
                color: color,
                fontFamily: "Brand-Regular",
                fontSize: 2.5 * SizeConfig.textMultiplier,
              ),),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
