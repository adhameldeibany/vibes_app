import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String uid, name, imgurl, email, nationality;
  Timestamp birthdate;
  List<dynamic> phone;

  UserModel({
    required this.uid,
    required this.name,
    required this.imgurl,
    required this.email,
    required this.phone,
    required this.nationality,
    required this.birthdate,
  });
}