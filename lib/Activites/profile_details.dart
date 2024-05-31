import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vibes/Activites/activity_details.dart';
import 'package:vibes/Backend/Models/ActivityModel.dart';
import 'package:vibes/Backend/Models/ActivityReviewModel.dart';
import 'package:vibes/Backend/Models/VendorModel.dart';
import 'package:vibes/Methods/colors_methods.dart';

late VendorModel vendorModel;
late int trating;
late int nrating;

class ProfileDetails extends StatefulWidget {
  ProfileDetails({required VendorModel Vendor, required int tRating, required int nRating}){
    vendorModel = Vendor;
    trating = tRating;
    nrating = nRating;
  }

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {

  bool b = false;

  @override
  Widget build(BuildContext context) {
    return getAllActivities(context);
  }

  List<ActivityModel> activities = [];

  getAllActivities(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('activities').where('vendorid',isEqualTo: vendorModel.id).snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            activities.clear();
            return getReviews(context);
          }
          else{

            activities.clear();
            final items = snapshot1.data!.docs;
            for(var item in items){
              activities.add(
                ActivityModel(
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
                    timetaken: item['timetaken']
                )
              );
            }
            return getReviews(context);
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

  int tstars = 0;
  int nstars = 0;
  Map<String,double> rv = {};
  List<ActivityReviewModel> actrevmods = [];


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
              return getFavs(context);
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
              return getFavs(context);
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

  List<dynamic> Favs = [];

  getFavs(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('favorites').where('uid',isEqualTo: '${FirebaseAuth.instance.currentUser!.uid.toString()}-a-').snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              Favs.clear();
              return DataScreen(context);
            }else{
              Favs.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                Favs.add({
                  "id": item['eventid'],
                  'state': true,
                });
              }
              return DataScreen(context);
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

  DataScreen(BuildContext context){
    var dateTime1 = DateFormat('dd/MM/yyyy').parse(vendorModel.exprience);
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {},
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
        title: Text(
          'Vendor profile',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        actions: [
          InkWell(
            onTap: () {},
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
                  child: Icon(
                    FontAwesomeIcons.ellipsisVertical,
                    color: Colors.black,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w,),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.h, right: 16.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 128.w,
                        height: 128.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(vendorModel.imgurl),
                            )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(vendorModel.name,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 156.sp,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('Activiteis Rating',
                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, fontFamily: 'Avenir'),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text((trating/nrating).toStringAsFixed(1),
                                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(width: 3.w,),
                                    Image(image: AssetImage('assets/stargrey.png')),
                                    SizedBox(width: 3.w,),
                                    Text('(${nrating})',
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 156.sp,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('Experience',
                                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, fontFamily: 'Avenir'),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('${(DateTime.now().difference(dateTime1).inDays/365.25).toStringAsFixed(0)}+ Years',
                                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 56.h,),
                  Row(
                    children: [
                      Text('All vendor’s activites',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h,),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: activities.length,
                itemBuilder: (context, index2) {
                  final act = activities[index2];
                  late double stars;
                  try{
                    stars = rv[act.id]!;
                  }catch(e){
                    stars = 0.0;
                  }
                  bool x = false;
                  var y = Favs.where((element) => element['id'] == act.id).toList();
                  if (y.length != 0) {
                    x = true;
                  }
                  return Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: InkWell(
                      onTap: (){
                        Get.to(ActivityDetails(
                          Vendormodel: vendorModel,
                          Fav: x,
                          ActivityModel: act,
                        ));
                      },
                      child: Container(
                        width: 260.sp,
                        height: 280.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(act.pic1),
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
                            padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 12.sp),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.sp),
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
                                    SizedBox(height: 3.sp,),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 150.w,
                                                  child: AutoSizeText(act.title,
                                                    maxLines: 2,
                                                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Avenir'),
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
                                                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Aviner'),
                                                ),
                                                AutoSizeText('.${act.startsfrom.split('.')[1]} EGP',
                                                  maxLines: 2,
                                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.grey[400], fontFamily: 'Aviner'),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
