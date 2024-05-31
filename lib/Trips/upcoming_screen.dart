import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibes/Activites/activity_details.dart';
import 'package:vibes/Backend/Models/TripsModel.dart';
import 'package:vibes/Events/events_details.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:vibes/Sights/sights_details.dart';
import 'package:vibes/Trips/trips_details.dart';

late List<TripsModel> trips;
List<dynamic> Favs = [];
List<TripsModel> alltrips = [];

List<TripsModel> filteredtrips = trips;
List<DateTime?> filterdates = [];
late List<String> Cities;
late Map<String,List<TripsModel>> newMap;
String selectedcity = '';
bool b = true;

class UpcomingScreen extends StatefulWidget {
  UpcomingScreen({required List<TripsModel> Trips, required List<String> cities, required  Map<String,List<TripsModel>> map }){
    trips = Trips;
    Cities = cities;
    newMap = map;
    alltrips.clear();
    alltrips.addAll(Trips);
  }

  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {

  int selectedValue1 = 0;
  int selectedValue2 = 0;
  int selectedValue3 = 0;
  void _handleRadioValueChange1(int value) {
    setState(() {
      selectedValue1 = value;
    });
  }

  void _handleRadioValueChange2(int value) {
    setState(() {
      selectedValue2 = value;
    });
  }

  void _handleRadioValueChange3(int value) {
    setState(() {
      selectedValue3 = value;
    });
  }

  int current = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return getFavs(context);
  }

  Future _bottomSheet1(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        barrierColor: Colors.grey.withOpacity(0.5),
        backgroundColor: background,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => Container(
            height: 500.h,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
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
                        Text('Trips date filter',
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(FontAwesomeIcons.xmark, color: Colors.black, size: 28,))
                      ],
                    ),
                    SizedBox(height: 15.h,),
                    CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        selectedDayHighlightColor: primary,
                        selectedRangeHighlightColor: secondery,
                        calendarType: CalendarDatePicker2Type.range,
                      ),
                      value: filterdates,
                      onValueChanged: (dates) {
                        this.setState(() {
                          if (dates.length == 2) {
                            filterdates = dates;
                          }
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: (){
                            filteredtrips.clear();
                            filteredtrips.addAll(alltrips);
                            this.setState(() {
                              print(alltrips.length);
                              filterdates.clear();
                            });
                            Navigator.pop(context);
                          },
                          child: Text('Reset',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14.sp),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            this.setState(() {
                              if (filterdates.length == 2) {
                                filterbydate();
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

  Future _bottomSheet2(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        barrierColor: Colors.grey.withOpacity(0.5),
        backgroundColor: background,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => Container(
            height: 600.h,
            child: SingleChildScrollView(
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
                        Text('Trips destination filter',
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(FontAwesomeIcons.xmark, color: Colors.black, size: 28,))
                      ],
                    ),
                    SizedBox(height: 20.h,),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: Cities.length,
                      itemBuilder: (context, index) {
                        final city = Cities[index];
                        print(newMap);
                        final String img = newMap[city]![0].cityimg;
                        return Column(
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  selectedValue2 = 1 as int;
                                });
                                this.setState(() {
                                  selectedcity = city;
                                });
                                _handleRadioValueChange2(1);
                              },
                              child: Container(
                                width: 328.w,
                                height: 80.h,
                                decoration: BoxDecoration(
                                  color: selectedcity==city ? secondery : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 80.sp,
                                          height: 80.sp,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                            image: DecorationImage(
                                              image: NetworkImage(img,),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 16.sp),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
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
                                    Transform.scale(
                                      scale: 1,
                                      child: Radio(
                                        activeColor: primary,
                                        value: city,
                                        groupValue: selectedcity,
                                        onChanged: (value) {
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h,),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 60.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: (){
                            this.setState(() {
                              filteredtrips.clear();
                              filteredtrips.addAll(alltrips);
                              selectedcity = '';
                            });
                            Navigator.pop(context);
                          },
                          child: Text('Reset',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14.sp),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                              filterbycity();
                            this.setState(() {
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

  Future _bottomSheet3(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        barrierColor: Colors.grey.withOpacity(0.5),
        backgroundColor: background,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => Container(
            height: 320.h,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Transform.scale(
                        scale: 0.2,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Divider(color: Colors.black, thickness: 30)
                        ),
                    ),
                    SizedBox(height: 10.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Trips prices',
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
                          selectedValue3 = 0 as int;
                        });
                        this.setState(() {
                          b = true;
                        });
                        _handleRadioValueChange3(0);
                      },
                      child: Container(
                        width: 328.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: b ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('High to low', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),),
                              Transform.scale(
                                scale: 1,
                                child: Radio(
                                  activeColor: primary,
                                  value: 0,
                                  groupValue: selectedValue3,
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
                          selectedValue3 = 1 as int;
                        });
                        this.setState(() {
                          b = false;
                        });
                        _handleRadioValueChange3(1);
                      },
                      child: Container(
                        width: 328.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: !b ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Low to high', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),),
                              Transform.scale(
                                scale: 1,
                                child: Radio(
                                  activeColor: primary,
                                  value: 1,
                                  groupValue: selectedValue3,
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
                          onPressed: (){
                            this.setState(() {
                            filteredtrips.clear();
                            filteredtrips.addAll(alltrips);
                            });
                            Navigator.pop(context);
                          },
                          child: Text('Reset',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14.sp),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            this.setState(() {
                              filterbyprice();
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
        title: Text('Upcoming trips',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
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
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      _bottomSheet1(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Date',
                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 2.w,),
                                Icon(Icons.keyboard_arrow_down_sharp, size: 18.sp,),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w,),
                  InkWell(
                    onTap: (){
                      _bottomSheet2(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText('Destination',
                                maxLines: 1,
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 2.w,),
                              Icon(Icons.keyboard_arrow_down_sharp, size: 18.sp,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w,),
                  InkWell(
                    onTap: (){
                      _bottomSheet3(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Price',
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 2.w,),
                              Icon(Icons.keyboard_arrow_down_sharp, size: 18.sp,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h,),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredtrips.length,
                itemBuilder: (context, index) {
                  final trip = filteredtrips[index];
                  bool x = false;
                  var y = Favs.where((element) => element['id'] == trip.id).toList();
                  if (y.length != 0) {
                    x = true;
                  }
                  return InkWell(
                    onTap: (){
                      Get.to(TripsDetails(tripsModel: trip,Fav: x,));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      width: 328.w,
                      height: 280.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(trip.pic1,),
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
                                      }
                                      else{
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
                                      SizedBox(
                                        width: 150.w,
                                        child: AutoSizeText(trip.from.substring(0,6),
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, color: Colors.white),
                                        ),
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
                                            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Aviner'),
                                          ),
                                          SizedBox(width: 2.w,),
                                          AutoSizeText('EGP',
                                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.grey[300], fontFamily: 'Aviner'),
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}

filterbydate(){
  filteredtrips.clear();
  for(var trip in alltrips){
    if ((trip.date.toDate().isAfter(DateTime(filterdates[0]!.year,filterdates[0]!.month,filterdates[0]!.day,0,0,0))) &&(trip.date.toDate().isBefore(DateTime(filterdates[1]!.year,filterdates[1]!.month,filterdates[1]!.day+1,0,0,0)))) {
      filteredtrips.add(trip);
      print(trip.name);
    }
  }
}
filterbycity(){
  filteredtrips.clear();
  filteredtrips.addAll(alltrips.where((element) => element.city == selectedcity));
}

filterbyprice(){
  if (!b) {
    filteredtrips.sort((a, b) => int.parse(a.price).compareTo(int.parse(b.price)));
  }else{
    filteredtrips.sort((a, b) => int.parse(b.price).compareTo(int.parse(a.price)));
  }
}
