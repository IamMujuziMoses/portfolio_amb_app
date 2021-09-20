import 'package:creativedata_ambulance_app/Assistants/assistantMethods.dart';
import 'package:creativedata_ambulance_app/Models/history.dart';
import 'package:creativedata_ambulance_app/Provider/appData.dart';
import 'package:creativedata_ambulance_app/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
/*
* Created by Mujuzi Moses
*/

class HistoryPage extends StatefulWidget {
  static const String screenId = "historyPage";
  const HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],

        title: Text("Trips History", style: TextStyle(fontFamily: "Brand Bold"),),
      ),
      body: Container(
        color: Colors.grey[100],
        width: MediaQuery.of(context).size.width,
        child: ListView.separated(
            itemBuilder: (context, index) {
              return HistoryItem(
                history: Provider.of<AppData>(context, listen: false).tripHistoryDataList[index],
              );
            },
            separatorBuilder: (context, int index) => Divider(thickness: 3,),
            itemCount: Provider.of<AppData>(context, listen: false).tripHistoryDataList.length,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
          ),
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  final History history;
  HistoryItem({Key key, this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Image.asset("images/user_icon.png", height: 16, width: 16,),
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                Expanded(
                  child: Container(
                    child: Text(history.riderName, style: TextStyle(
                      fontSize: 2.5 * SizeConfig.textMultiplier,
                      color: Colors.red[300],
                      fontFamily: "Brand Bold",
                      fontWeight: FontWeight.w400,
                    ), overflow: TextOverflow.ellipsis,),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Image.asset("images/pickicon.png", height: 16, width: 16,),
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                Expanded(
                  child: Container(
                    child: Text(history.pickUp, style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Brand-Regular",
                    ), overflow: TextOverflow.ellipsis,),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Image.asset("images/desticon.png", height: 16, width: 16,),
                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                Text(history.dropOff, overflow: TextOverflow.ellipsis, style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Band-Regular",
                ),),
              ],
            ),
          ),
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          Text(AssistantMethods.formatTripDate(history.createdAt), style: TextStyle(
            color: Colors.grey,
          ),),
        ],
      ),
    );
  }
}

