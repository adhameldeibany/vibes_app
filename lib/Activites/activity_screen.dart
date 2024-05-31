import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibes/Activites/activity_details.dart';
import 'package:vibes/Backend/Models/ActivityModel.dart';
import 'package:vibes/Backend/Models/ActivityReviewModel.dart';
import 'package:vibes/Backend/Models/VendorModel.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:vibes/Sights/sights_details.dart';
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {

  int selectedValue = 0;
  bool a = true;
  bool b = false;

  void _handleRadioValueChange(int value) {
    setState(() {
      selectedValue = value;
    });
  }

  List<String> items = [
    "Dahab",
    "Siwa",
    "Sharm el-Sheikh",
  ];

  int current = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return getdata(context);
  }

  // ==================================================================================> Methods <=========================================================================

  Map<String,List<ActivityModel>> newMap = {};
  List<String> locations = [];
  List<ActivityModel> activities = [];

  getdata(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('activities').snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return Placeholder();
          }
          else{
            final items = snapshot1.data!.docs;
            activities.clear();
            locations.clear();
            newMap.clear();
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
            for(var key in newMap.keys) {
              locations.add(key);
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
    final ref = FirebaseFirestore.instance.collection('favorites').where('uid',isEqualTo: '${FirebaseAuth.instance.currentUser!.uid.toString()}-a-').snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              Favs.clear();
              return getReviews(context);
            }else{
              Favs.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                Favs.add({
                  "id": item['eventid'],
                  'state': true,
                });
              }
              return getReviews(context);
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

  int tstars = 0;
  int nstars = 0;
  Map<String,double> rv = {};
  List<ActivityReviewModel> actrevmods = [];

  int il = 0;

  getReviews(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('activitiesreviews').orderBy('actid').snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              for(var acti in activities){
                rv[acti.id] = 0.0;
              }
              return dataScreen(context);
            }else{
              actrevmods.clear();
              rv.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                ActivityReviewModel actr = new ActivityReviewModel(
                    uid: item['uid'],
                    msg: item['msg'],
                    stars: item['stars'],
                    date: item['date'],
                    actid: item['actid'],
                    vendorid: item['vendorid'],
                  id: item['id'],
                );
                actrevmods.add(actr);
              }

              Map<String,List<ActivityReviewModel>> actres = groupBy(actrevmods, (ActivityReviewModel obj) => obj.actid);

              for(var key in actres.keys) {
                tstars = 0;
                nstars = 0;
                for(var k in actres[key]!){
                  tstars += int.parse(k.stars);
                  nstars +=1;
                }
                rv[key] = tstars/nstars;
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
        title: Text('Activities',
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
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                                    AutoSizeText(
                                      loc,
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
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.77,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: newMap[locations[current]]!.length,
                        itemBuilder: (context, index2) {
                          final act = newMap[locations[current]]![index2];
                          bool x = false;
                          var y = Favs.where((element) => element['id'] == act.id).toList();
                          if (y.length != 0) {
                            x = true;
                          }
                          late double stars;
                          try{
                            stars = rv[act.id]!;
                          }catch(e){
                            stars = 0.0;
                          }
                          return InkWell(
                            onTap: (){
                              Get.to(ActivityDetails(ActivityModel: act,Fav: x,Vendormodel: vend[act.id]!,));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              width: 328.w,
                              height: 280.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: NetworkImage(act.pic1,),
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
                                              child: Transform.scale(
                                                scale: 1.1,
                                                child: Text(act.timetaken,
                                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir',),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              if (x) {
                                                FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-a-'+act.id).delete().then(
                                                      (doc) => print("Document deleted"),
                                                  onError: (e) => print("Error updating document $e"),
                                                );
                                              }else{
                                                final favevent = <String, String>{
                                                  "uid": "${FirebaseAuth.instance.currentUser!.uid.toString()}-a-",
                                                  "eventid": act.id,
                                                };

                                                FirebaseFirestore.instance
                                                    .collection("favorites")
                                                    .doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-a-'+act.id)
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
                                              Transform.scale(
                                                  scale: (stars >=1 || stars>0)?1.3:0.8,
                                                  child: stars>=1?
                                                      Image(image: AssetImage('assets/whitestar.png', ))
                                                      :stars>0?
                                                      Image(image: AssetImage('assets/starhalfwhite.png'))
                                                      :Image(image: AssetImage('assets/star.png', ),color: Colors.white,)
                                              ),
                                              SizedBox(width: 8.w,),
                                              Transform.scale(
                                                  scale: (stars >=2 || stars>1)?1.3:0.8,
                                                  child: stars>=2?
                                                  Image(image: AssetImage('assets/whitestar.png', ))
                                                      :stars>1?
                                                  Image(image: AssetImage('assets/starhalfwhite.png'))
                                                      :Image(image: AssetImage('assets/star.png', ),color: Colors.white,)
                                              ),
                                              SizedBox(width: 8.w,),
                                              Transform.scale(
                                                  scale: (stars >=3 || stars>2)?1.3:0.8,
                                                  child: stars>=3?
                                                  Image(image: AssetImage('assets/whitestar.png', ))
                                                      :stars>2?
                                                  Image(image: AssetImage('assets/starhalfwhite.png'))
                                                      :Image(image: AssetImage('assets/star.png', ),color: Colors.white,)
                                              ),
                                              SizedBox(width: 8.w,),
                                              Transform.scale(
                                                  scale: (stars >=4 || stars>3)?1.3:0.8,
                                                  child: stars>=4?
                                                  Image(image: AssetImage('assets/whitestar.png', ))
                                                      :stars>3?
                                                  Image(image: AssetImage('assets/starhalfwhite.png'))
                                                      :Image(image: AssetImage('assets/star.png', ),color: Colors.white,)
                                              ),
                                              SizedBox(width: 5.w,),
                                              Transform.scale(
                                                  scale: (stars >=5 || stars>4)?1.3:0.8,
                                                  child: stars>=5?
                                                  Image(image: AssetImage('assets/whitestar.png', ))
                                                      :stars>4?
                                                  Image(image: AssetImage('assets/starhalfwhite.png'))
                                                      :Image(image: AssetImage('assets/star.png', ),color: Colors.white,)
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 150.w,
                                                        child: AutoSizeText(act.title,
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
                                                        child: AutoSizeText(vend[act.id]!.name,
                                                          maxLines: 2,
                                                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.grey[400], fontFamily: 'Aviner'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
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
                                                      AutoSizeText(act.startsfrom.split('.')[0],
                                                        maxLines: 2,
                                                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Aviner'),
                                                      ),
                                                      AutoSizeText('.${act.startsfrom.split('.')[1]} EGP',
                                                        maxLines: 2,
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
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
