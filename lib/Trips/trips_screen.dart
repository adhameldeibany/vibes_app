import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:vibes/Backend/Models/TripsModel.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:vibes/Trips/trips_details.dart';
import 'package:vibes/Trips/upcoming_screen.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {

  bool b = false;

  @override
  Widget build(BuildContext context) {
    return getdata(context);
  }

  Map<String,List<TripsModel>> newMap = {};
  List<String> cities = [];
  List<TripsModel> trips = [];

  getdata(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('trips').orderBy('date').snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return getFavs(context);
          }
          else{
            final items = snapshot1.data!.docs;
            trips.clear();
            cities.clear();
            newMap.clear();
            for(var item in items){

              TripsModel trip = new TripsModel(
                  id: item['id'],
                  name: item['name'],
                  location: item['location'],
                  lat: item['lat'],
                  lon: item['lon'],
                  city: item['city'],
                  length: item['length'],
                  price: item['price'],
                  about: item['about'],
                  vendorid: item['vendorid'],
                  from: item['from'],
                  to: item['to'],
                  hotel: item['hotel'],
                  room: item['room'],
                  pic1: item['pic1'],
                  pic2: item['pic2'],
                  pic3: item['pic3'],
                  catering: item['catering'],
                  travel: item['travel'],
                  date: item['date'],
                  cityimg: item['cityimg'],
              );

              trips.add(trip);
            }

            newMap = groupBy(trips, (TripsModel obj) => obj.city);
            for(var key in newMap.keys) {
              cities.add(key);
            }
            return getFavs(context);
          }
        } else {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  color: background
              ),
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Center(
                child: Container(
                  width: 100.sp,
                  height: 100.sp,
                  child: CircularProgressIndicator(
                    color: primary,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );

  }

  List<dynamic> Favs = [];

  getFavs(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('favorites').where('uid',isEqualTo: '${FirebaseAuth.instance.currentUser!.uid.toString()}-t-').snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              Favs.clear();
              return dataScreen(context);
            }else{
              Favs.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                Favs.add({
                  "id": item['eventid'],
                  'state': true,
                });
              }
              return dataScreen(context);
            }
          }else{
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                    color: background
                ),
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: Center(
                  child: Container(
                    width: 100.sp,
                    height: 100.sp,
                    child: CircularProgressIndicator(
                      color: primary,
                    ),
                  ),
                ),
              ),
            );
          }
        }
    );
  }

  dataScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: (){},
            child: Container(
              width: 32.sp,
              height: 32.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Transform.scale(
                  scale: 1.1,
                  child: BackButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text('Trips',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        actions: [
          Container(
            width: 35.sp,
            height: 35.sp,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Transform.scale(
                scale: 1.1,
                child: Icon(Icons.search, color: Colors.black, size: 20.sp,),
              ),
            ),
          ),
          SizedBox(width: 15.w,),
          Container(
            width: 35.sp,
            height: 35.sp,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Transform.scale(
                scale: 1.1,
                child: Icon(FontAwesomeIcons.ellipsisVertical, color: Colors.black, size: 18.sp,),
              ),
            ),
          ),
          SizedBox(width: 15.w,),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15.sp,),
            Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cities',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500,),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.sp,),
            Container(
              alignment: Alignment.centerLeft,
              constraints: BoxConstraints(maxHeight: 210.sp),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  final String img = newMap[city]![0].cityimg;
                  return Padding(
                    padding: EdgeInsets.only(left: 16.sp),
                    child: InkWell(
                      onTap: (){},
                      child: Container(
                        height: 210.sp,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 140.sp,
                              height: 140.sp,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                image: DecorationImage(
                                  image: NetworkImage(img,),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16.sp, top: 16.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(city,
                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                  ),
                                  Text('${newMap[city]!.length.toString()}+ trip',
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.sp,),
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Upcoming trips',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500,),
                  ),
                  TextButton(
                    onPressed: (){
                      Get.to(UpcomingScreen(Trips: trips,cities: cities,map: newMap,));
                    },
                    child: Text('See all',
                      style: TextStyle(color: Colors.black, fontSize: 13.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              constraints: BoxConstraints(maxHeight: 360.sp),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: trips.length>=5? 5: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  bool x = false;
                  var y = Favs.where((element) => element['id'] == trip.id).toList();
                  if (y.length != 0) {
                    x = true;
                  }
                  return Padding(
                    padding: EdgeInsets.only(left: 16.sp),
                    child: InkWell(
                      onTap: (){
                        Get.to(TripsDetails(tripsModel: trip, Fav: x,));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.sp),
                        width: 242.sp,
                        height: 360.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(trip.pic1,),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color(0xff1E1E1E).withOpacity(1),
                                ],
                                stops: [0.0,1.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 20.sp),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(trip.city,
                                          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir', color: Colors.white),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on_outlined, color: Colors.white, size: 20,),
                                            SizedBox(width: 3.w,),
                                            Center(
                                              child: Text(trip.location,
                                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, fontFamily: 'Avenir', color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: (){
                                        if (x) {
                                          FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-t-'+trip.id).delete().then(
                                                (doc) => print("Document deleted"),
                                            onError: (e) => print("Error updating document $e"),
                                          );
                                        }else{
                                          final favevent = <String, String>{
                                            "uid": "${FirebaseAuth.instance.currentUser!.uid.toString()}-t-",
                                            "eventid": trip.id,
                                          };

                                          FirebaseFirestore.instance
                                              .collection("favorites")
                                              .doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-t-'+trip.id)
                                              .set(favevent)
                                              .onError((e, _) => print("Error writing document: $e"));
                                        }
                                      },
                                      child: Container(
                                        width: 32.sp,
                                        height: 32.sp,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Transform.scale(
                                            scale: 1.1,
                                            child: Icon(x ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, color: x ? Colors.black : Colors.black, size: 20,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('From',
                                          style: TextStyle(color: Colors.white, fontFamily: 'Avenir', fontSize: 14.sp),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        AutoSizeText(trip.from.substring(0,6),
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        AutoSizeText(trip.length,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.grey[200], fontFamily: 'Aviner'),
                                        ),
                                        Row(
                                          children: [
                                            AutoSizeText(trip.price,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Aviner'),
                                            ),
                                            SizedBox(width: 2.sp,),
                                            AutoSizeText('EGP',
                                              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: Colors.grey[300], fontFamily: 'Aviner'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.sp),
          ],
        ),
      ),
    );
  }

}
