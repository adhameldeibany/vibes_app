import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:vibes/Backend/GlobalMethods.dart';
import 'package:vibes/Backend/Models/SightModel.dart';
import 'package:vibes/Backend/Models/SightReviewModel.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:vibes/Sights/sights_details.dart';

List<SightModel> sights = [];
late double Lat;
late double Lon;
class SightsScreen extends StatefulWidget {
  SightsScreen({required double lat, required double lon}){
    Lat = lat;
    Lon = lon;
  }

  @override
  State<SightsScreen> createState() => _SightsScreenState();
}

class _SightsScreenState extends State<SightsScreen> {

  @override
  Widget build(BuildContext context) {
    return MakeStream(context);
  }

  Widget MakeStream(BuildContext context) {
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
              SightModel sight = new SightModel(
                id: item['id'],
                name: item['name'],
                about: item['about'],
                lat: item['lat'],
                lon: item['lon'],
                img1: item['img1'],
                img2: item['img2'],
                img3: item['img3'],
              );
              sights.add(sight);
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
  List<SightReviewModel> actrevmods = [];

  int il = 0;

  getReviews(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('sightsreviews').orderBy('sightid').snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              for(var sigh in sights){
                rv[sigh.id] = 0.0;
              }
              return DataScreen();
            }else{
              actrevmods.clear();
              rv.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                SightReviewModel actr = new SightReviewModel(
                  uid: item['uid'],
                  msg: item['msg'],
                  stars: item['stars'],
                  date: item['date'],
                  sightid: item['sightid'],
                  id: item['id'],
                );
                actrevmods.add(actr);
              }

              Map<String,List<SightReviewModel>> actres = groupBy(actrevmods, (SightReviewModel obj) => obj.sightid);

              for(var key in actres.keys) {
                tstars = 0;
                nstars = 0;
                for(var k in actres[key]!){
                  tstars += int.parse(k.stars);
                  nstars +=1;
                }
                rv[key] = tstars/nstars;
              }
              return DataScreen();
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

  DataScreen(){
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
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
        title: Text(
          'Sights',
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
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: sights.length,
                itemBuilder: (context, index) {
                  final sigh = sights[index];
                  late double stars;
                  try{
                    stars = rv[sigh.id]!;
                  }catch(e){
                    stars = 0.0;
                  }
                  final dist = GlobalMethods().distance(Lat, Lon, double.parse(sigh.lat), double.parse(sigh.lon));
                  return Column(
                    children: [
                      InkWell(
                        onTap: (){
                          Get.to(SightsDetails(Sight: sigh,));
                        },
                        child: Container(
                          width: 328.sp,
                          height: 240.sp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 328.sp,
                                height: 176.sp,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                                  image: DecorationImage(
                                    image: NetworkImage(sigh.img1,),
                                    fit: BoxFit.cover,
                                  ),
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
                                        Text(dist.toStringAsFixed(1),
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
                                        Text(sigh.name,
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                        Row(
                                          children: [
                                            Text(stars.toStringAsFixed(1),
                                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: nonselectedtext),
                                            ),
                                            Text('/5',
                                              style: TextStyle(fontSize: 10.sp, color: nonselectedtext),
                                            ),
                                          ],
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
              ),
            ),
          ],
        ),
      ),
    );
  }

}
