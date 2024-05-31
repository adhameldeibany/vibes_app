import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:vibes/Activites/activity_details.dart';
import 'package:vibes/Activites/activity_screen.dart';
import 'package:vibes/Backend/GlobalMethods.dart';
import 'package:vibes/Backend/Models/ActivityModel.dart';
import 'package:vibes/Backend/Models/EventModel.dart';
import 'package:vibes/Backend/Models/SightModel.dart';
import 'package:vibes/Backend/Models/TripsModel.dart';
import 'package:vibes/Backend/Models/UserModel.dart';
import 'package:vibes/Events/events_details.dart';
import 'package:vibes/Events/events_screen.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibes/Sights/sights_details.dart';
import 'package:vibes/Sights/sights_screen.dart';
import 'package:vibes/Trips/trips_details.dart';
import 'package:vibes/Trips/trips_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({required UserModel User}){
    user = User;
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

late Position position;
late UserModel user;
late String city;
List<ActivityModel> activities = [];
List<SightModel> sights = [];
List<EventModel> events = [];
List<TripsModel> trips = [];
List<int> indexs = [0,0,0,0];
List<double> distances1 = [];
List<double> distances2 = [];
List<double> distances3 = [];
List<double> distances4 = [];
List<dynamic> Favs1 = [];
List<dynamic> Favs2 = [];
List<dynamic> Favs3 = [];
List<dynamic> Favs4 = [];

class _HomeScreenState extends State<HomeScreen> {

  List<String> pages = ['Sights','Activities','Events','Trips',];

  TextEditingController searchcontroller = new TextEditingController();
  bool k = false;

  @override
  void didChangeDependencies() async{
    await _handleLocationPermission();
    setState(() {

    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return getLocation(context);
  }

  getLocation(BuildContext context){
    return FutureBuilder(
      future: Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
          );;
        } else if (snapshot.hasData) {
          position = snapshot.data!;
          return getCity(context);
        } else {
          position = new Position(longitude: 31.233334, latitude: 30.033333, timestamp: DateTime.timestamp(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);
          return getCity(context);
        }
      },
    );
  }

  getCity(BuildContext context){
    return FutureBuilder(
      future: placemarkFromCoordinates(
      position.latitude,
      position.longitude,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
          );;
        } else if (snapshot.hasData) {
          List<Placemark> placemarks = snapshot.data!;
          city = placemarks[0].subAdministrativeArea.toString();
          return getActivities(context);
        } else {
          city = 'No GPS Allocated, Egypt';
          position = new Position(longitude: 31.233334, latitude: 30.033333, timestamp: DateTime.timestamp(), accuracy: 0, altitude: 0, altitudeAccuracy: 0, heading: 0, headingAccuracy: 0, speed: 0, speedAccuracy: 0);

          return getActivities(context);
        }
      },
    );
  }

  getActivities(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('activities').snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return Placeholder();
          }
          else{
            distances1.clear();
            activities.clear();
            final items = snapshot1.data!.docs;
            for(var item in items){

              ActivityModel activity = new ActivityModel(
                id: item['id'],
                title: item['title'],
                vendorid: item['vendorid'],
                startsfrom: item['startsfrom'],
                about: item['about'],
                loc: item['loc'],
                pickfrom: item['pickfrom'],
                professionalguideid: item['professionalguideid'],
                age: item['age'],
                ID: item['ID'],
                dresscode: item['dresscode'],
                lat: item['lat'],
                lon: item['lon'],
                pic1: item['pic1'],
                pic2: item['pic2'],
                pic3: item['pic3'],
                timetaken: item['timetaken'],
              );

              distances1.add(double.parse(
                  GlobalMethods().distance(
                      position.latitude,
                      position.longitude,
                      double.parse(activity.lat),
                      double.parse(activity.lon)
                  ).toStringAsFixed(2)));
              activities.add(activity);
            }
            return getSights(context);
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

  getSights(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('sights').snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return Placeholder();
          }
          else{
            distances2.clear();
            sights.clear();
            final items = snapshot1.data!.docs;
            for(var item in items){

              SightModel sightModel = new SightModel(
                  id: item['id'],
                  name: item['name'],
                  about: item['about'],
                  lat: item['lat'],
                  lon: item['lon'],
                  img1: item['img1'],
                  img2: item['img2'],
                  img3: item['img3']
              );

              distances2.add(double.parse(
                  GlobalMethods().distance(
                      position.latitude,
                      position.longitude,
                      double.parse(sightModel.lat),
                      double.parse(sightModel.lon)
                  ).toStringAsFixed(2)));
              sights.add(sightModel);
            }

            return getEvents(context);
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

  getEvents(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('events').snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return Placeholder();
          }
          else{
            distances3.clear();
            events.clear();
            final items = snapshot1.data!.docs;
            for(var item in items){

              EventModel eventModel = new EventModel(
                  id: item['id'],
                  name: item['name'],
                  startdate: item['startdate'],
                  about: item['about'],
                  pic1: item['pic1'],
                  pic2: item['pic2'],
                  pic3: item['pic3'],
                  enddate: item['enddate'],
                  occur: item['occur'],
                  lat: item['lat'],
                  lon: item['lon']
              );

              distances3.add(double.parse(
                  GlobalMethods().distance(
                      position.latitude,
                      position.longitude,
                      double.parse(eventModel.lat),
                      double.parse(eventModel.lon)
                  ).toStringAsFixed(2)));
              events.add(eventModel);
            }

            return getTrips(context);
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

  getTrips(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('trips').snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return Placeholder();
          }
          else{
            distances4.clear();
            trips.clear();
            final items = snapshot1.data!.docs;
            for(var item in items){

              TripsModel tripsModel = new TripsModel(
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
                  cityimg: item['cityimg']
              );

              distances4.add(double.parse(
                  GlobalMethods().distance(
                      position.latitude,
                      position.longitude,
                      double.parse(tripsModel.lat),
                      double.parse(tripsModel.lon)
                  ).toStringAsFixed(2)));
              trips.add(tripsModel);
            }

            return getSightsFav(context);
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

  getSightsFav(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('favorites').where('uid',isEqualTo: '${FirebaseAuth.instance.currentUser!.uid.toString()}-s-').snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              Favs1.clear();
              return getActivitiesFav(context);
            }else{
              Favs1.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                Favs1.add({
                  "id": item['eventid'],
                  'state': true,
                });
              }
              return getActivitiesFav(context);
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

  getActivitiesFav(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('favorites').where('uid',isEqualTo: '${FirebaseAuth.instance.currentUser!.uid.toString()}-a-').snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              Favs2.clear();
              return getEventsFav(context);
            }else{
              Favs2.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                Favs2.add({
                  "id": item['eventid'],
                  'state': true,
                });
              }
              return getEventsFav(context);
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

  getEventsFav(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('favorites').where('uid',isEqualTo: '${FirebaseAuth.instance.currentUser!.uid.toString()}').snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              Favs3.clear();
              return getTripsFav(context);
            }else{
              Favs3.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                Favs3.add({
                  "id": item['eventid'],
                  'state': true,
                });
              }
              return getTripsFav(context);
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

  getTripsFav(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('favorites').where('uid',isEqualTo: '${FirebaseAuth.instance.currentUser!.uid.toString()}-t-').snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              Favs4.clear();
              return dataScreen(context);
            }else{
              Favs4.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                Favs4.add({
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

  dataScreen(BuildContext context){
    return Scaffold(
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 10.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello,',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          Text(user.name.split(' ')[0],
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 18.sp,),
                              SizedBox(width: 3.w,),
                              Text(city,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 24.h,),
                  SizedBox(
                    height: 50.h,
                    width: 328.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:  BorderRadius.circular(8),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
                          hintText: 'Search for Sights, Events...',
                          hintStyle: TextStyle(color: Color(0xffACACAC), fontSize: 12.sp),
                          prefixIcon: Icon(Icons.search, color: Color(0xffACACAC), size: 18.sp,),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h,),
                  Row(
                    children: [
                      Text('Discover',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h,),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Container(
                constraints: BoxConstraints(maxHeight: 116.sp),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return InkWell(
                      onTap: () {
                        if (index == 0) {
                          Get.to(SightsScreen(lat: position.latitude,lon: position.longitude,));
                        }else if(index == 1){
                          Get.to(ActivityScreen());
                        }else if(index == 2){
                          Get.to(EventScreen());
                        }else{
                          Get.to(TripsScreen());
                        }
                      },
                      child: Container(
                        width: 100.sp,
                        height: 116.sp,
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.h,),
                            Center(
                              child: Container(
                                width: 84.sp,
                                height: 48.sp,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage('assets/home1.png',),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.sp, top: 8.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(page,
                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    index==0? sights.length.toString()
                                      :
                                    index==1? activities.length.toString()
                                      :
                                    index==2? events.length.toString()
                                      :
                                    trips.length.toString()
                                    ,
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 32.h,),
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recommended Nearby',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    onTap: (){},
                    child: Text('See all',
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h,),
            Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Container(
                constraints: BoxConstraints(maxHeight: 320.sp),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    late dynamic model;
                    bool x = false;
                    if (index == 0) {
                      model = getMin(distances2,sights,index);
                      var y = Favs1.where((element) => element['id'] == model.id).toList();
                      if (y.length != 0) {
                        x = true;
                      }
                    }
                    if (index == 1) {
                      model = getMin(distances1,activities,index);
                      var y = Favs2.where((element) => element['id'] == model.id).toList();
                      if (y.length != 0) {
                        x = true;
                      }
                    }
                    if (index == 2) {
                      model = getMin(distances3,events,index);
                      var y = Favs3.where((element) => element['id'] == model.id).toList();
                      if (y.length != 0) {
                        x = true;
                      }
                    }
                    if (index == 3) {
                      model = getMin(distances4,trips,index);
                      var y = Favs4.where((element) => element['id'] == model.id).toList();
                      if (y.length != 0) {
                        x = true;
                      }
                    }
                    return InkWell(
                      onTap: (){
                        if (index == 0) {
                          Get.to(SightsDetails(Sight: model));
                        }else if(index == 1){
                          Get.to(ActivityDetails(ActivityModel: model, Fav: x, fromhome: true));
                        }else if (index == 2) {
                          Get.to(EventDetails(eventModel: model, Fav: x));
                        }else{
                          Get.to(TripsDetails(tripsModel: model, Fav: x));
                        }
                      },
                      child: Container(
                        width: 200.sp,
                        height: 320.sp,
                        margin: EdgeInsets.only(right: 16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200.sp,
                              height: 200.sp,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      index==0?sights[indexs[index]].img1:
                                      index==1?activities[indexs[index]].pic1:
                                      index==2?events[indexs[index]].pic1:
                                      trips[indexs[index]].pic1,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 16.h, right: 16.w),
                                        child: InkWell(
                                          onTap: (){
                                            if (index == 0) {
                                              if (x) {
                                                FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-s-'+model.id).delete().then(
                                                      (doc) => print("Document deleted"),
                                                  onError: (e) => print("Error updating document $e"),
                                                );
                                              }else{
                                                final favevent = <String, String>{
                                                  "uid": "${FirebaseAuth.instance.currentUser!.uid.toString()}-s-",
                                                  "eventid": model.id,
                                                };

                                                FirebaseFirestore.instance
                                                    .collection("favorites")
                                                    .doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-s-'+model.id)
                                                    .set(favevent)
                                                    .onError((e, _) => print("Error writing document: $e"));
                                              }
                                            }else if (index == 1) {
                                              if (x) {
                                                FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-a-'+model.id).delete().then(
                                                      (doc) => print("Document deleted"),
                                                  onError: (e) => print("Error updating document $e"),
                                                );
                                              }else{
                                                final favevent = <String, String>{
                                                  "uid": "${FirebaseAuth.instance.currentUser!.uid.toString()}-a-",
                                                  "eventid": model.id,
                                                };

                                                FirebaseFirestore.instance
                                                    .collection("favorites")
                                                    .doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-a-'+model.id)
                                                    .set(favevent)
                                                    .onError((e, _) => print("Error writing document: $e"));
                                              }
                                            }else if(index == 2){
                                              if (x) {
                                                FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-'+model.id).delete().then(
                                                      (doc) => print("Document deleted"),
                                                  onError: (e) => print("Error updating document $e"),
                                                );
                                              }else{
                                                final favevent = <String, String>{
                                                  "uid": "${FirebaseAuth.instance.currentUser!.uid.toString()}",
                                                  "eventid": model.id,
                                                };

                                                FirebaseFirestore.instance
                                                    .collection("favorites")
                                                    .doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-'+model.id)
                                                    .set(favevent)
                                                    .onError((e, _) => print("Error writing document: $e"));
                                              }
                                            }else{
                                              if (x) {
                                                FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-t-'+model.id).delete().then(
                                                      (doc) => print("Document deleted"),
                                                  onError: (e) => print("Error updating document $e"),
                                                );
                                              }else{
                                                final favevent = <String, String>{
                                                  "uid": "${FirebaseAuth.instance.currentUser!.uid.toString()}-t-",
                                                  "eventid": model.id,
                                                };

                                                FirebaseFirestore.instance
                                                    .collection("favorites")
                                                    .doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-t-'+model.id)
                                                    .set(favevent)
                                                    .onError((e, _) => print("Error writing document: $e"));
                                              }
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
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16.sp, top: 16.sp, right: 16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(page,
                                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: primary),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h,),
                                  AutoSizeText(index==1?model.title:model.name,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, color: primary, size: 12.sp,),
                                      SizedBox(width: 5.w,),
                                      Text(
                                        index==0?distances2[indexs[index]].toString():
                                        index==1?distances1[indexs[index]].toString():
                                        index==2?distances3[indexs[index]].toString():
                                        distances4[indexs[index]].toString(),
                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                                      ),
                                      Text(' km nearby',
                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: nonselectedtext),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16.h,),
          ],
        ),
      ),
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  getMin(List<double> list, List list2, int inde){
    double x = list.reduce(min);
    int index = list.indexOf(x);
    indexs[inde] = index;
    return list2[index];
  }

}
