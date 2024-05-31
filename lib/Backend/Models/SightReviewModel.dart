import 'package:cloud_firestore/cloud_firestore.dart';

class SightReviewModel{
  String uid, msg, stars, sightid, id;
  Timestamp date;

  SightReviewModel(
      {
        required this.uid,
        required this.msg,
        required this.stars,
        required this.date,
        required this.sightid,
        required this.id,
      }
      );
}