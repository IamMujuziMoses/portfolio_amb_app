import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
* Created by Mujuzi Moses
*/

class ProgressDialog extends StatelessWidget {
  String message;
  ProgressDialog({
    this.message
});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.red[300],
      child: Container(
        margin: EdgeInsets.all(15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red[300],
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(width: 6.0,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
              SizedBox(width: 25.0,),
              Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
