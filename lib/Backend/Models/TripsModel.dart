import 'package:cloud_firestore/cloud_firestore.dart';

class TripsModel{
  String id, name, location, lat, lon, city, length, price, about, vendorid, from, to, hotel, room, pic1, pic2, pic3, catering, travel, cityimg;
  Timestamp date;

  TripsModel({
    required this.id,
    required this.name,
    required this.location,
    required this.lat,
    required this.lon,
    required this.city,
    required this.length,
    required this.price,
    required this.about,
    required this.vendorid,
    required this.from,
    required this.to,
    required this.hotel,
    required this.room,
    required this.pic1,
    required this.pic2,
    required this.pic3,
    required this.catering,
    required this.travel,
    required this.date,
    required this.cityimg,
  });
}