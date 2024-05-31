import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String uid, msg, stars;
  Timestamp date;

  ReviewModel(
      {
        required this.uid,
        required this.msg,
        required this.stars,
        required this.date
      }
      );
}