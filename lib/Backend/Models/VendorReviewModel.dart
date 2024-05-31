import 'package:cloud_firestore/cloud_firestore.dart';

class VendorReviewModel{
  String uid, msg, stars, vendorid, id;
  Timestamp date;

  VendorReviewModel(
      {
        required this.uid,
        required this.msg,
        required this.stars,
        required this.date,
        required this.vendorid,
        required this.id
      }
      );
}