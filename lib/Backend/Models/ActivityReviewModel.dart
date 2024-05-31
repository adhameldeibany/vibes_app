import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityReviewModel{
  String uid, msg, stars, actid, vendorid, id;
  Timestamp date;

  ActivityReviewModel(
      {
        required this.uid,
        required this.msg,
        required this.stars,
        required this.date,
        required this.actid,
        required this.vendorid,
        required this.id,
      }
      );
}