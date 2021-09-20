import 'package:cloud_firestore/cloud_firestore.dart';
/*
* Created by Mujuzi Moses
*/

class History{
  String createdAt;
  String status;
  String dropOff;
  String pickUp;
  String riderName;

  History({this.riderName, this.createdAt, this.status, this.dropOff, this.pickUp,});

  History.fromSnapshot(DocumentSnapshot historySnap) {
    createdAt = historySnap.get("created_at");
    status = historySnap.get("status");
    dropOff = historySnap.get("dropOff_address");
    pickUp = historySnap.get("pickUp_address");
    riderName = historySnap.get("rider_name");
  }
}