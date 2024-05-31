import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:vibes/Activites/activity_details.dart';
import 'package:vibes/Activites/review_activity.dart';
import 'package:vibes/Backend/GlobalMethods.dart';
import 'package:vibes/Backend/Models/ActivityModel.dart';
import 'package:vibes/Backend/Models/EventModel.dart';
import 'package:vibes/Backend/Models/SightModel.dart';
import 'package:vibes/Backend/Models/TripsModel.dart';
import 'package:vibes/Backend/Models/VendorModel.dart';
import 'package:vibes/Events/events_details.dart';
import 'package:vibes/Home/home_screen.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:vibes/Sights/sights_details.dart';
import 'package:vibes/Trips/trips_details.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {

  bool x = false;
  bool f = false;
  bool b = false;
  List<String> locations = ['All','Sights','Activities','Events','Trips',];
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return getActivities(context);
  }

  List<dynamic> Favs1 = [];
  List<dynamic> Favs2 = [];
  List<dynamic> Favs3 = [];
  List<dynamic> Favs4 = [];
  List<ActivityModel> activities = [];
  List<SightModel> sights = [];
  List<EventModel> events = [];
  List<TripsModel> trips = [];

  getFavs1(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('favorites').where('uid',isEqualTo: '${FirebaseAuth.instance.currentUser!.uid.toString()}-s-').snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              Favs1.clear();
              return getFavs2(context);
            }else{
              Favs1.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                Favs1.add({
                  "id": item['eventid'],
                  'state': true,
                });
              }
              return getFavs2(context);
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

  getFavs2(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('favorites').where('uid',isEqualTo: '${FirebaseAuth.instance.currentUser!.uid.toString()}-a-').snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              Favs2.clear();
              return getFavs3(context);
            }else{
              Favs2.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                Favs2.add({
                  "id": item['eventid'],
                  'state': true,
                });
              }
              return getFavs3(context);
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

  getFavs3(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('favorites').where('uid',isEqualTo: '${FirebaseAuth.instance.currentUser!.uid.toString()}').snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              Favs3.clear();
              return getFavs4(context);
            }else{
              Favs3.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                Favs3.add({
                  "id": item['eventid'],
                  'state': true,
                });
              }
              return getFavs4(context);
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

  getFavs4(BuildContext context){
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

  Map<String,List<ActivityModel>> newMap = {};

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

              activities.add(activity);
            }
            newMap = groupBy(activities, (ActivityModel obj) => obj.loc);
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

              trips.add(tripsModel);
            }

            return getvendors(context);
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

  List<VendorModel> vendors = [];
  Map<String,VendorModel> vend = {};

  getvendors(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('vendors').snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return Placeholder();
          }
          else{
            final items = snapshot1.data!.docs;
            vendors.clear();
            vend.clear();

            for(var item in items){

              VendorModel vendor = new VendorModel(
                  id: item['id'],
                  name: item['name'],
                  exprience: item['Experience'],
                  imgurl: item['imgurl']
              );
              vendors.add(vendor);
            }

            for(var value in newMap.values) {
              for(var val in value){
                for(var v in vendors){
                  if (val.vendorid == v.id) {
                    vend[val.id] = v;
                    break;
                  }
                }
              }
            }
            return getFavs1(context);
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

  dataScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        title: Text(
          'Wishlist',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Transform.scale(
              scale: 1.1,
              child: Icon(
                Icons.settings_outlined,
                color: Colors.black,
                size: 24.sp,
              ),
            ),
          ),
          SizedBox(width: 15.w,),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Column(
            children: [
              SizedBox(height: 20.h,),
              SizedBox(
                width: double.infinity,
                height: 65.h,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: locations.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final loc = locations[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                current = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration:  Duration(milliseconds: 300),
                              margin:  EdgeInsets.all(5),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: current == index ? lightblack : background,
                                borderRadius: BorderRadius.circular(64),
                                border: Border.all(color: lightblack, width: 1.5),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AutoSizeText(loc,
                                      maxLines: 2,
                                      style: TextStyle(color: current == index ? Colors.white : lightblack, fontWeight: FontWeight.w600, fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              SizedBox(height: 10.h,),
              (current==0 || current==1)?ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: Favs1.length,
                itemBuilder: (context, index) {
                  final fav = Favs1[index];
                  bool y = true;
                  var s = sights.where((element) => element.id == fav['id']).toList()[0];
                  return Column(
                    children: [
                      InkWell(
                        onTap: (){
                          Get.to(SightsDetails(Sight: s,));
                        },
                        child: Container(
                          width: 328.sp,
                          height: 160.sp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 328.sp,
                                height: 96.sp,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                  image: DecorationImage(
                                    image: NetworkImage(s.img1,),
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
                                              FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-s-'+s.id).delete().then(
                                                    (doc) => print("Document deleted"),
                                                onError: (e) => print("Error updating document $e"),
                                              );
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
                                                  child: Icon(y ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, color: y ? Colors.black : Colors.black, size: 20,),
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
                                      children: [
                                        Icon(Icons.location_on, color: primary, size: 12.sp,),
                                        SizedBox(width: 5.w,),
                                        Text(GlobalMethods().distance(position.latitude, position.longitude, double.parse(s.lat), double.parse(s.lon)).toStringAsFixed(1),
                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                                        ),
                                        Text(' km nearby',
                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: nonselectedtext),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(s.name,
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h,),
                    ],
                  );
                },
              ):SizedBox(),
              (current==0 || current==4)?ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: Favs4.length,
                itemBuilder: (context, index) {
                  final fav = Favs4[index];
                  bool y = true;
                  var s = trips.where((element) => element.id == fav['id']).toList()[0];
                  return Column(
                    children: [
                      InkWell(
                        onTap: (){
                          Get.to(TripsDetails(Fav: y,tripsModel: s,));
                        },
                        child: Container(
                          width: 328.sp,
                          height: 160.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(s.pic1,),
                              fit: BoxFit.cover,
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
                                      Text(s.city,
                                        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir', color: Colors.white),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-t-'+s.id).delete().then(
                                                (doc) => print("Document deleted"),
                                            onError: (e) => print("Error updating document $e"),
                                          );
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
                                              child: Icon(y ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, color: y ? Colors.black : Colors.black, size: 20,),
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
                                          Text('From ${s.from.substring(0,6)}',
                                            style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText(s.length,
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 12.sp, color: Colors.grey[200]),
                                          ),
                                          Row(
                                            children: [
                                              AutoSizeText(s.price,
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
                      SizedBox(height: 16.h,),
                    ],
                  );
                },
              ):SizedBox(),
              (current==0 || current==3)?ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: Favs3.length,
                itemBuilder: (context, index) {
                  final fav = Favs3[index];
                  bool y = true;
                  var s = events.where((element) => element.id == fav['id']).toList()[0];
                  return Column(
                    children: [
                      InkWell(
                        onTap: (){
                          Get.to(EventDetails(eventModel: s, Fav: y));
                        },
                        child: Container(
                          width: 328.sp,
                          height: 160.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(s.pic1,),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [Color(0xff0A0A0A00), Color(0xff0A0A0A)],
                                  begin: Alignment(0.0, -0.3),
                                  end: Alignment(0, 1),
                                )
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: InkWell(
                                        onTap: (){
                                          FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-'+s.id).delete().then(
                                                (doc) => print("Document deleted"),
                                            onError: (e) => print("Error updating document $e"),
                                          );
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
                                              child: Icon(y ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, color: y ? Colors.black : Colors.black, size: 20,),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                                  child: Row(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 232.w
                                        ),
                                        child: AutoSizeText(s.name,
                                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h,),
                    ],
                  );
                },
              ):SizedBox(),
              (current==0 || current==2)?ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: Favs2.length,
                itemBuilder: (context, index) {
                  final fav = Favs2[index];
                  bool y = true;
                  var s = activities.where((element) => element.id == fav['id']).toList()[0];
                  return Column(
                    children: [
                      InkWell(
                        onTap: (){
                          Get.to(ActivityDetails(ActivityModel: s, Fav: fav,Vendormodel: vend[s.id]!,));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16.h),
                          width: 328.w,
                          height: 160.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(s.pic1),
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
                              padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 32.sp,
                                        padding: EdgeInsets.only(left: 12.w, right: 12.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text('${s.timetaken}',
                                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir',),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-a-'+s.id).delete().then(
                                                (doc) => print("Document deleted"),
                                            onError: (e) => print("Error updating document $e"),
                                          );
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
                                              child: Icon(y ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, color: y ? Colors.black : Colors.black, size: 20,),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 150.w,
                                                    child: AutoSizeText(s.title,
                                                      maxLines: 2,
                                                      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 150.w,
                                                    child: AutoSizeText(vend[s.id]!.name,
                                                      maxLines: 2,
                                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.grey[400], fontFamily: 'Aviner'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  AutoSizeText('Starts from',
                                                    maxLines: 2,
                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.grey[400], fontFamily: 'Aviner'),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  AutoSizeText(s.startsfrom.split('.')[0],
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Aviner'),
                                                  ),
                                                  AutoSizeText('.${s.startsfrom.split('.')[1]} EGP',
                                                    maxLines: 1,
                                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.grey[400], fontFamily: 'Aviner'),
                                                  ),
                                                ],
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
                      SizedBox(height: 16.h,),
                    ],
                  );
                },
              ):SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
