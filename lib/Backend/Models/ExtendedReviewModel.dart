import 'package:cloud_firestore/cloud_firestore.dart';

class ExtendedReviewModel {
  String uid, msg, stars, name, imgurl;
  String id;
  Timestamp date;

  ExtendedReviewModel(
      {
        required this.uid,
        required this.msg,
        required this.stars,
        required this.date,
        required this.name,
        required this.imgurl,
        required this.id
      }
      );
}