import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id, name, about, pic1, pic2, pic3, occur, lat, lon;
  Timestamp startdate,enddate;

  EventModel(
  {
    required this.id,
    required this.name,
    required this.startdate,
    required this.about,
    required this.pic1,
    required this.pic2,
    required this.pic3,
    required this.enddate,
    required this.occur,
    required this.lat,
    required this.lon,
  }
  );
}