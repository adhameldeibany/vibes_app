import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_machine/time_machine.dart';
import 'package:vibes/Backend/Models/EventModel.dart';
import 'package:vibes/Events/events_details.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:vibes/Sights/sights_details.dart';
import 'package:vibes/Backend/NavigationPack/Vibespages.dart' as Vpages;


List<dynamic> Favs = [];

String Sheet = 'All events';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  int selectedValue = 0;
  bool a = true;
  bool b = false;
  Timestamp d = Timestamp.fromDate(DateTime(1990,DateTime.january,1));

  void _handleRadioValueChange(int value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
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
                    scale: 1.2,
                    child: BackButton(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          title: Text('Events',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          actions: [
            InkWell(
              onTap: (){},
              child: Container(
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
            ),
            SizedBox(width: 15.w,),
            InkWell(
              onTap: (){},
              child: Container(
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
            ),
            SizedBox(width: 15.w,),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h,),
                Container(
                  width: 328.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TabBar(
                    indicatorColor: Colors.black,
                    dividerColor: Colors.white,
                    labelColor: Colors.white,
                    physics: ClampingScrollPhysics(),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black
                    ),
                    labelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                    tabs: [
                      SizedBox(
                          width: 150.w,
                          child: Tab(text: 'Upcoming')),
                      SizedBox(
                          width: 150.w,
                          child: Tab(text: 'My events')),
                      SizedBox(
                          width: 150.w,
                          child: Tab(text: 'Favorite')),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.8,
                  child: TabBarView(
                      children: [
                        FirstMakeStream(context),
                        GetMyEvents(),
                        ThirdMakeStream(context)
                      ]
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _bottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        barrierColor: Colors.grey.withOpacity(0.5),
        backgroundColor: background,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Container(
              height: 320.h,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Transform.scale(
                        scale: 0.2,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Divider(color: Colors.black, thickness: 30))
                    ),
                    SizedBox(height: 10.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Events filter',
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(FontAwesomeIcons.xmark, color: Colors.black, size: 28,))
                      ],
                    ),
                    SizedBox(height: 30.h,),
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedValue = 0 as int;
                        });
                        this.setState(() {
                          a = true;
                        });
                        _handleRadioValueChange(0);
                      },
                      child: Container(
                        width: 328.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: a ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('All events', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),),
                              Transform.scale(
                                scale: 1,
                                child: Radio(
                                  activeColor: primary,
                                  value: 0,
                                  groupValue: selectedValue,
                                  onChanged: (value) {
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedValue = 1 as int;
                        });
                        this.setState(() {
                          a = false;
                        });
                        _handleRadioValueChange(1);
                      },
                      child: Container(
                        width: 328.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: !a ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Soonest', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),),
                              Transform.scale(
                                scale: 1,
                                child: Radio(
                                  activeColor: primary,
                                  value: 1,
                                  groupValue: selectedValue,
                                  onChanged: (value) {
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 60.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: (){},
                            child: Text('Reset',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14.sp),
                            ),
                        ),
                        InkWell(
                          onTap: (){
                            this.setState(() {
                              Sheet = a ? 'All events' : 'Soonest';
                              if (a) {
                                d = Timestamp.fromDate(DateTime(1990,DateTime.january,1));
                              }else{
                                d = Timestamp.fromDate(DateTime.now());
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 39.h,
                            width: 250.w,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(666),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12, right: 12),
                              child: Center(
                                child: Text('Apply',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.w,),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }


  /* ---------------------------------------------------------------- Methods ---------------------------------------------------------------- */

  List<String> months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  List<List<String>> days = [];
  Map<String,List<EventModel>> newMap = {};
  List<List<String>> days2 = [];
  List<List<String>> days3 = [];
  Map<String,List<EventModel>> newMap2 = {};
  Map<String,List<EventModel>> newMap3 = {};
  List<EventModel> events = [];
  List<EventModel> myevns = [];
  List<LocalDate> dates = [];
  List<LocalDate> dates2 = [];
  List<LocalDate> dates3 = [];
  List<EventModel> favevents = [];

  GetFavs(int x){
    final ref = FirebaseFirestore.instance.collection('favorites').where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString()).snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              Favs.clear();
              favevents.clear();
              if (x==3) {
                days2.clear();
                newMap2.clear();
                dates2.clear();
                newMap2 = groupBy(favevents, (EventModel obj) => obj.startdate.toDate().toString().substring(0,10));
                for(var key in newMap2.keys){
                  LocalDate aa = LocalDate.dateTime(DateTime(int.parse(key.substring(0,4)),int.parse(key.substring(5,7)),int.parse(key.substring(8,10))));
                  dates2.add(aa);
                  days2.add([key,key.substring(8,10),months[int.parse(key.substring(5,7))-1]]);
                }
              }
              return x==1?FirstDataScreen():ThirdDataScreen(context);
            }else{
              Favs.clear();
              favevents.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                Favs.add({
                  "id": item['eventid'],
                  'state': true,
                });
                for(var ev in events){
                  if (ev.id == item['eventid']) {
                    favevents.add(ev);
                    break;
                  }
                }
              }

              if (x==3) {
                days2.clear();
                newMap2.clear();
                dates2.clear();
                newMap2 = groupBy(favevents, (EventModel obj) => obj.startdate.toDate().toString().substring(0,10));
                for(var key in newMap2.keys){
                  LocalDate aa = LocalDate.dateTime(DateTime(int.parse(key.substring(0,4)),int.parse(key.substring(5,7)),int.parse(key.substring(8,10))));
                  dates2.add(aa);
                  days2.add([key,key.substring(8,10),months[int.parse(key.substring(5,7))-1]]);
                }
              }

              return x==1?FirstDataScreen():ThirdDataScreen(context);
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

  GetMyEvents(){
    final dbref = FirebaseDatabase.instance.ref('myevents').child(FirebaseAuth.instance.currentUser!.uid.toString());
    return Builder(
      builder: (context) => StreamBuilder(
        stream: dbref.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null && (snapshot.data! as DatabaseEvent).snapshot.value != null) {
            myevns.clear();
            final myevents = Map<dynamic, dynamic>.from((snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>);
            myevents.forEach((key, value) {
              final currentevent = Map<String, dynamic>.from(value);
              for(var ev in events) {
                if(currentevent['eventid'] == ev.id){
                  myevns.add(ev);
                }
              }
            });
            days3.clear();
            newMap3.clear();
            dates3.clear();
            newMap3 = groupBy(myevns, (EventModel obj) => obj.startdate.toDate().toString().substring(0,10));
            for(var key in newMap3.keys){
              LocalDate aa = LocalDate.dateTime(DateTime(int.parse(key.substring(0,4)),int.parse(key.substring(5,7)),int.parse(key.substring(8,10))));
              dates3.add(aa);
              days3.add([key,key.substring(8,10),months[int.parse(key.substring(5,7))-1]]);
            }
            return SecondDataScreen(context);
            //
          }else if (snapshot.connectionState == ConnectionState.waiting) {
            print('Loading');
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
          else{
            myevns.clear();
            days3.clear();
            newMap3.clear();
            dates3.clear();
            newMap3 = groupBy(myevns, (EventModel obj) => obj.startdate.toDate().toString().substring(0,10));
            for(var key in newMap3.keys){
              LocalDate aa = LocalDate.dateTime(DateTime(int.parse(key.substring(0,4)),int.parse(key.substring(5,7)),int.parse(key.substring(8,10))));
              dates3.add(aa);
              days3.add([key,key.substring(8,10),months[int.parse(key.substring(5,7))-1]]);
            }
            return SecondDataScreen(context);
          }
        },
      ),
    );
  }

  Widget FirstMakeStream(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection('events').where('startdate',isGreaterThanOrEqualTo: d).orderBy('startdate').snapshots();

    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              return Placeholder();
            }
            else{
              final items = snapshot1.data!.docs;
              events.clear();
              days.clear();
              newMap.clear();
              for(var item in items){
                EventModel event = new EventModel(
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
                    lon: item['lon'],
                );
                events.add(event);
              }

              dates.clear();
              newMap = groupBy(events, (EventModel obj) => obj.startdate.toDate().toString().substring(0,10));
              for(var key in newMap.keys){
                LocalDate aa = LocalDate.dateTime(DateTime(int.parse(key.substring(0,4)),int.parse(key.substring(5,7)),int.parse(key.substring(8,10))));
                dates.add(aa);
                days.add([key,key.substring(8,10),months[int.parse(key.substring(5,7))-1]]);
              }
              return GetFavs(1);
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

  Widget ThirdMakeStream(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection('events').where('startdate',isGreaterThanOrEqualTo: d).orderBy('startdate').snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return Placeholder();
          }else{
            final items = snapshot1.data!.docs;
            favevents.clear();
            return GetFavs(3);
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

  FirstDataScreen(){
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: (){
                  _bottomSheet(context);
                },
                child: Container(
                  width: 102.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Sheet,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ),
                      SizedBox(width: 10.h,),
                      Icon(Icons.arrow_drop_down, size: 16.sp, color: Colors.black,),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h,),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 50.sp,
                          height: 64.sp,
                          decoration: BoxDecoration(
                            color: Color(0xff1E1E1E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(day[1],
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16.sp, fontFamily: 'Avenir'),
                              ),
                              Text(day[2],
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16.sp, fontFamily: 'Avenir'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 316.h + 175.h*(newMap[day[0]]!.length-2),
                          child: VerticalDivider(
                            thickness: 1.5,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 262.w,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: newMap[day[0]]!.length,
                        itemBuilder: (context, index2) {
                          final event = newMap[day[0]]![index2];
                          bool x = false;
                          var y = Favs.where((element) => element['id'] == event.id).toList();
                          if (y.length != 0) {
                            x = true;
                          }
                          return InkWell(
                            onTap: (){
                              Get.to(EventDetails(eventModel: event,Fav: x,));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              width: 262.w,
                              height: 160.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: NetworkImage(event.pic1,),
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
                                              if (x) {
                                                FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-'+event.id).delete().then(
                                                      (doc) => print("Document deleted"),
                                                  onError: (e) => print("Error updating document $e"),
                                                );
                                              }else{
                                                final favevent = <String, String>{
                                                  "uid": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                  "eventid": event.id,
                                                };

                                                FirebaseFirestore.instance
                                                    .collection("favorites")
                                                    .doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-'+event.id)
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
                                            child: AutoSizeText(event.name,
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
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
          ),
        ],
      ),
    );
  }

  ThirdDataScreen(BuildContext context){
    if (favevents.length == 0) {
      return Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: (){
                  _bottomSheet(context);
                },
                child: Container(
                  width: 102.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('All events',
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ),
                      SizedBox(width: 10.h,),
                      Icon(Icons.arrow_drop_down, size: 16, color: Colors.black,),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200.w,
                    child: AutoSizeText('You don\'t have favorite events',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  Image(image: AssetImage('assets/emptyFav.png')),
                  SizedBox(height: 30.h,),
                  SizedBox(
                    width: 220.w,
                    child: AutoSizeText('Start exploring upcoming events and add to your favorites',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    ),
                  ),
                  SizedBox(height: 80.h,),
                  InkWell(
                    onTap: (){
                      setState(() {
                      });
                    },
                    child: Container(
                      width: 328.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(64),
                      ),
                      child: Center(
                        child: Text('Explore now',
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }
    else{
      return SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: (){
                    _bottomSheet(context);
                  },
                  child: Container(
                    width: 102.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(Sheet,
                          style: TextStyle(color: Colors.black, fontSize: 12.sp),
                        ),
                        SizedBox(width: 10.h,),
                        Icon(Icons.arrow_drop_down, size: 16.sp, color: Colors.black,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: days2.length,
                itemBuilder: (context, index) {
                  final day = days2[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 50.sp,
                            height: 64.sp,
                            decoration: BoxDecoration(
                              color: Color(0xff1E1E1E),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(day[1],
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16.sp, fontFamily: 'Avenir'),
                                ),
                                Text(day[2],
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16.sp, fontFamily: 'Avenir'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 316.h + 175.h*(newMap2[day[0]]!.length-2),
                            child: VerticalDivider(
                              thickness: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 262.w,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: newMap2[day[0]]!.length,
                          itemBuilder: (context, index2) {
                            final event = newMap2[day[0]]![index2];
                            bool x = false;
                            var y = Favs.where((element) => element['id'] == event.id).toList();
                            if (y.length != 0) {
                              x = true;
                            }
                            return InkWell(
                              onTap: (){
                                Get.to(EventDetails(eventModel: event,Fav: x,));
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16.h),
                                width: 262.w,
                                height: 160.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: NetworkImage(event.pic1,),
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
                                                if (x) {
                                                  FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-'+event.id).delete().then(
                                                        (doc) => print("Document deleted"),
                                                    onError: (e) => print("Error updating document $e"),
                                                  );
                                                }else{
                                                  final favevent = <String, String>{
                                                    "uid": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                    "eventid": event.id,
                                                  };

                                                  FirebaseFirestore.instance
                                                      .collection("favorites")
                                                      .doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-'+event.id)
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
                                              child: AutoSizeText(event.name,
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
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
            ),
          ],
        ),
      );
    }
  }

  SecondDataScreen(BuildContext context){
    if (myevns.length == 0) {
      return Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: (){
                  _bottomSheet(context);
                },
                child: Container(
                  width: 102.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('All events',
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ),
                      SizedBox(width: 10.h,),
                      Icon(Icons.arrow_drop_down, size: 16, color: Colors.black,),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200.w,
                    child: AutoSizeText('You don\'t have scheduled events',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  Image(image: AssetImage('assets/emptyevent.png')),
                  SizedBox(height: 30.h,),
                  SizedBox(
                    width: 220.w,
                    child: AutoSizeText('Start exploring upcoming events and add to your calendar',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(color: Colors.black, fontSize: 16.sp),
                    ),
                  ),
                  SizedBox(height: 80.h,),
                  InkWell(
                    onTap: (){},
                    child: Container(
                      width: 328.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(64),
                      ),
                      child: Center(
                        child: Text('Explore now',
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }else{
      return SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: (){
                    _bottomSheet(context);
                  },
                  child: Container(
                    width: 102.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(Sheet,
                          style: TextStyle(color: Colors.black, fontSize: 12.sp),
                        ),
                        SizedBox(width: 10.h,),
                        Icon(Icons.arrow_drop_down, size: 16.sp, color: Colors.black,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: days3.length,
                itemBuilder: (context, index) {
                  final day = days3[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 50.sp,
                            height: 64.sp,
                            decoration: BoxDecoration(
                              color: Color(0xff1E1E1E),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(day[1],
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16.sp, fontFamily: 'Avenir'),
                                ),
                                Text(day[2],
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16.sp, fontFamily: 'Avenir'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 316.h + 175.h*(newMap3[day[0]]!.length-2),
                            child: VerticalDivider(
                              thickness: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 262.w,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: newMap3[day[0]]!.length,
                          itemBuilder: (context, index2) {
                            final event = newMap3[day[0]]![index2];
                            bool x = false;
                            var y = Favs.where((element) => element['id'] == event.id).toList();
                            if (y.length != 0) {
                              x = true;
                            }
                            return InkWell(
                              onTap: (){
                                Get.to(EventDetails(eventModel: event,Fav: x,));
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16.h),
                                width: 262.w,
                                height: 160.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: NetworkImage(event.pic1,),
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
                                                if (x) {
                                                  FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-'+event.id).delete().then(
                                                        (doc) => print("Document deleted"),
                                                    onError: (e) => print("Error updating document $e"),
                                                  );
                                                }else{
                                                  final favevent = <String, String>{
                                                    "uid": FirebaseAuth.instance.currentUser!.uid.toString(),
                                                    "eventid": event.id,
                                                  };

                                                  FirebaseFirestore.instance
                                                      .collection("favorites")
                                                      .doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-'+event.id)
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
                                              child: AutoSizeText(event.name,
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
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
            ),
          ],
        ),
      );
    }
  }

}
