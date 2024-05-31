import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibes/Backend/Models/ExtendedReviewModel.dart';
import 'package:vibes/Backend/Models/InstructionModel.dart';
import 'package:vibes/Backend/Models/ProgramModel.dart';
import 'package:vibes/Backend/Models/TripsImageModel.dart';
import 'package:vibes/Backend/Models/TripsModel.dart';
import 'package:vibes/Backend/Models/VendorModel.dart';
import 'package:vibes/Backend/Models/VendorReviewModel.dart';
import 'package:vibes/Events/minimap.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibes/Trips/vender_details.dart';
import 'package:weatherapi/weatherapi.dart';

late TripsModel trip;
late bool x;
late VendorModel vendor;
List<bool> expands = [];
WeatherRequest wr = WeatherRequest('55f4f0467a404effbe9212412240605', language: Language.english);

List<String> W_dates = ['2024-05-07'];
List<String> W_maxc = ['29'];
List<String> W_minc = ['15'];
List<String> W_icons = ['//cdn.weatherapi.com/weather/64x64/day/113.png'];
List<String> W_rains = ['0'];
List<String> months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov','Dec'];

class TripsDetails extends StatefulWidget {
  TripsDetails({required TripsModel tripsModel, required bool Fav}){
    x = Fav;
    trip = tripsModel;
  }

  @override
  State<TripsDetails> createState() => _TripsDetailsState();
}

class _TripsDetailsState extends State<TripsDetails> {
  bool a = false;
  bool b = false;
  bool s = true;

  @override
  Widget build(BuildContext context) {
    return getVendor(context);
  }

  void showToast() => Fluttertoast.showToast(
      msg: "Done, You will get an alert on time",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: primary,
      textColor: Colors.white,
      timeInSecForIosWeb: 1,
      webShowClose: true,
      fontSize: 16.sp
  );

  //================================================================> MH Methods <========================================

  getWeatherForecast(BuildContext context){
    W_dates.clear();
    W_icons.clear();
    W_maxc.clear();
    W_minc.clear();
    W_rains.clear();
    return FutureBuilder(
      future: wr.getForecastWeatherByLocation(double.parse(trip.lat), double.parse(trip.lon),forecastDays: 8),
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
          ForecastWeather fw = snapshot.data!;
          for(var weath in fw.forecast){
            W_dates.add(weath.date!);
            W_icons.add(weath.day.condition.icon!);
            W_maxc.add(weath.day.maxtempC!.toStringAsFixed(0));
            W_minc.add(weath.day.mintempC!.toStringAsFixed(0));
            W_rains.add(weath.day.dailyChanceOfRain!.toStringAsFixed(0));
          }
          return dataScreen(context);
        } else {
          return const Text("No data available");
        }
      },
    );
  }

  getVendor(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('vendors').doc(trip.vendorid).snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data == null) {
            return Placeholder();
          }
          else{
            final item = snapshot1.data!;
            vendor = new VendorModel(
                id: item['id'],
                name: item['name'],
                exprience: item['Experience'],
                imgurl: item['imgurl'],
                facebook: item['facebook'],
                insta: item['instagram'],
                website: item['website']
            );

            return ReviewStream(context);
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


  ExtendedReviewModel myreview = ExtendedReviewModel(
      uid: "",
      msg: "",
      stars: "",
      date: Timestamp.fromDate(DateTime.now()),
      imgurl: "",
      name: "",
      id: '',
  );
  List<VendorReviewModel> reviews = [];
  List<TripsImageModel> images = [];

  int tstars = 0;
  int nstars = 0;
  List<InstructionModel> instructions = [];
  List<ProgramModel> programs = [];

  ReviewStream(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('vendorreviews').where('vendorid',isEqualTo: trip.vendorid).snapshots();
    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            tstars = 0;
            nstars = 0;
            reviews.clear();
            myreview = ExtendedReviewModel(uid: "", msg: "", stars: "", date: Timestamp.fromDate(DateTime.now()),imgurl: "",name: "",id:'');
            return getImages(context);
          }
          else{
            final items = snapshot1.data!.docs;
            reviews.clear();
            tstars = 0;
            nstars = 0;
            for(var item in items){
              VendorReviewModel review = new VendorReviewModel(
                  uid: item['uid'],
                  msg: item['msg'],
                  stars: item['stars'],
                  date: item['date'],
                  vendorid: item['vendorid'],
                  id: item['id']
              );
              tstars += int.parse(review.stars);
              nstars +=1;
              reviews.add(review);
            }
            return getImages(context);
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

  getImages(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('tripsimages').where('tripid',isEqualTo: trip.id).snapshots();
    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            images.clear();
            return getinstructions(context);
          }
          else{
            final items = snapshot1.data!.docs;
            images.clear();
            for(var item in items){
              TripsImageModel tripsImageModel = new TripsImageModel(
                  img: item['img'],
                  vendorid: item['vendorid'],
                  tripid: item['tripid']
              );

              images.add(tripsImageModel);
            }
            return getinstructions(context);
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

  getinstructions(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('trips').doc(trip.id).collection('instructions').orderBy('id').snapshots();
    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            instructions.clear();
            return Placeholder();
          }
          else{
            final items = snapshot1.data!.docs;
            instructions.clear();
            for(var item in items){

              InstructionModel inst = new InstructionModel(
                  name: item['name'],
                  state: item['state'],
                  content: item['content'],
                  id: item['id']
              );

              instructions.add(inst);
            }
            return getWeatherForecast(context);
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

  getProgram(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('trips').doc(trip.id).collection('program').orderBy('id').snapshots();
    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            programs.clear();
            return SecondScreen(context);
          }
          else{
            final items = snapshot1.data!.docs;
            programs.clear();
            for(var item in items){

              ProgramModel prog = new ProgramModel(
                title: item['title'],
                content: item['content'],
                id: item['id']
              );

              programs.add(prog);
            }

            if (programs.length != expands.length || expands.length == 0) {
              expands.clear();
              for(int i = 0; i<programs.length; i++){
                expands.add(false);
              }
            }

            return SecondScreen(context);
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
            trip.name,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          actions: [
            InkWell(
              onTap: () {
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
                setState(() {
                  x = !x;
                });
              },
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
                      x ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, color: x ? Colors.black : Colors.black,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15.w,),
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
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 230.h,
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: background,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h,),
                        Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 260.w,
                                          height: 160.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(16),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                index==0?trip.pic1:index==1?trip.pic2:trip.pic3,
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: TabBar(
                  indicatorColor: primary,
                  dividerColor: background,
                  labelColor: primary,
                  labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
                  tabs: [
                    SizedBox(width: 150.w, child: Tab(text: 'Details')),
                    SizedBox(width: 150.w, child: Tab(text: 'Program')),
                    SizedBox(width: 150.w, child: Tab(text: 'Tickets')),
                  ],
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, top: 10),
            child: TabBarView(
                children: [
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 328.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'About',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  ReadMoreText(
                                    trip.about,
                                    style: TextStyle(fontSize: 10.sp),
                                    trimLines: 4,
                                    colorClickableText: Colors.black,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Read more',
                                    trimExpandedText: 'Read less',
                                    moreStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: primary,
                                    ),
                                    lessStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h,),
                          Container(
                            width: 328.sp,
                            height: 120.sp,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 15.sp),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Vendor',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp
                                        ),),
                                      TextButton(
                                        onPressed: (){
                                          Get.to(VendorDetails(Vendor: vendor));
                                        },
                                        child: Text('See more',
                                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 48.sp,
                                            height: 48.sp,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: NetworkImage(vendor.imgurl),
                                                )
                                            ),
                                          ),
                                          SizedBox(width: 5.w,),
                                          SizedBox(
                                            width: 120.w,
                                            child: AutoSizeText(vendor.name,
                                              maxLines: 2,
                                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 15),
                                            child: Row(
                                              children: [
                                                (tstars/nstars) >=1?
                                                Image(image: AssetImage('assets/stargrey.png', ))
                                                    :(tstars/nstars) >=0?Image(image: AssetImage('assets/starhalfgrey.png', ))
                                                    :Image(image: AssetImage('assets/star.png',),color: Color(0xffACACAC),height: 12.sp,width: 12.sp,),
                                                SizedBox(width: 3.w,),
                                                (tstars/nstars) >=2?
                                                Image(image: AssetImage('assets/stargrey.png', ))
                                                    :(tstars/nstars) >=1?Image(image: AssetImage('assets/starhalfgrey.png', ))
                                                    :Image(image: AssetImage('assets/star.png',),color: Color(0xffACACAC),height: 12.sp,width: 12.sp,),
                                                SizedBox(width: 3.w,),
                                                (tstars/nstars) >=3?
                                                Image(image: AssetImage('assets/stargrey.png', ))
                                                    :(tstars/nstars) >=2?Image(image: AssetImage('assets/starhalfgrey.png', ))
                                                    :Image(image: AssetImage('assets/star.png',),color: Color(0xffACACAC),height: 12.sp,width: 12.sp,),
                                                SizedBox(width: 3.w,),
                                                (tstars/nstars) >=4?
                                                Image(image: AssetImage('assets/stargrey.png', ))
                                                    :(tstars/nstars) >=3?Image(image: AssetImage('assets/starhalfgrey.png', ))
                                                    :Image(image: AssetImage('assets/star.png',),color: Color(0xffACACAC),height: 12.sp,width: 12.sp,),
                                                SizedBox(width: 3.w,),
                                                (tstars/nstars) >=5?
                                                Image(image: AssetImage('assets/stargrey.png', ))
                                                    :(tstars/nstars) >=4?Image(image: AssetImage('assets/starhalfgrey.png', ))
                                                    :Image(image: AssetImage('assets/star.png',),color: Color(0xffACACAC),height: 12.sp,width: 12.sp,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h,),
                          Container(
                            width: 328.sp,
                            height: 170.sp,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Booking details',
                                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                                      ),
                                      Text(trip.length,
                                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h,),
                                  Row(
                                    children: [
                                      Text('Travel dates',
                                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('From',
                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                                      ),
                                      Text(trip.from,
                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('To',
                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                                      ),
                                      Text(trip.to,
                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h,),
                          Container(
                            width: 328.w,
                            height: 360.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Accommodation details: ',
                                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 140.sp,
                                        height: 64.sp,
                                        decoration: BoxDecoration(
                                          color: Color(0xffF5F5F5),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Hotel name',
                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(trip.hotel,
                                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 140.sp,
                                        height: 64.sp,
                                        decoration: BoxDecoration(
                                          color: Color(0xffF5F5F5),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Room',
                                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(trip.room,
                                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h,),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      width: 328.w,
                                      height: 120.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12.sp),
                                      ),
                                      child: Stack(
                                          children:[
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12.sp),
                                                child: MiniMap(
                                                  eventname: trip.name,
                                                  eventdescription: trip.about,
                                                  Latitude:double.parse(trip.lat),
                                                  Longitude:double.parse(trip.lon),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                        onTap: (){
                                                          launchUrl(Uri.parse("http://maps.google.com/maps?&daddr=${trip.lat},${trip.lon}"));
                                                        },
                                                        child: Container(
                                                          width: 126.w,
                                                          height: 32.h,
                                                          decoration: BoxDecoration(
                                                              color: Color(0xff404040),
                                                              borderRadius: BorderRadius.circular(16),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    blurRadius: 5
                                                                )
                                                              ]
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.directions_outlined, color: Colors.white, size: 24,),
                                                              SizedBox(width: 5.w,),
                                                              Text('Directions',
                                                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]

                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.h,),
                                  Expanded(
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: images.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(left: 8.sp),
                                          child: Container(
                                            width: 100.sp,
                                            height: 100.sp,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              image: DecorationImage(
                                                image: NetworkImage(images[index].img,),
                                                fit: BoxFit.fill,
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
                          ),
                          SizedBox(height: 16.h,),
                          Container(
                            width: 328.w,
                            height: 110.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text('Catering',
                                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(trip.catering,
                                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h,),
                          Container(
                            width: 328.w,
                            height: 110.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text('Travel Documents',
                                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(maxWidth: 200.w),
                                        child: AutoSizeText(trip.travel,
                                          maxLines: 2,
                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Weather forecast',
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 18,),
                                  SizedBox(width: 3.w,),
                                  Text(trip.location,
                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h,),
                          Container(
                            width: 328.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ExpansionTile(
                                iconColor: Colors.black,
                                collapsedIconColor: Colors.black,
                                expandedCrossAxisAlignment: CrossAxisAlignment.end,
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(W_dates[0].substring(8,10)+' '+months[int.parse(W_dates[0].substring(5,7))],
                                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.water_drop_outlined, size: 15,),
                                            Text(W_rains[0]+"%",
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 10.w,),
                                        ImageIcon(NetworkImage("https:"+W_icons[0]), size: 25.sp,),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(W_minc[0]+'°',
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                        SizedBox(width: 10.w,),
                                        Text(W_maxc[0]+'°',
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                children: [
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: W_minc.length-1,
                                    itemBuilder: (context, index) {
                                      return  Container(
                                        width: 328.w,
                                        height: 64.h,
                                        decoration: BoxDecoration(
                                          color: index %2 == 0 ? background : Colors.white,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(W_dates[index+1].substring(8,10)+' '+months[int.parse(W_dates[index+1].substring(5,7))],
                                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.water_drop_outlined, size: 18,),
                                                      Text('${W_rains[index+1]}%'),
                                                    ],
                                                  ),
                                                  SizedBox(width: 10.w,),
                                                  ImageIcon(NetworkImage("https:"+W_icons[index+1]), size: 25.sp,),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(W_minc[index+1]+'°'),
                                                  SizedBox(width: 10.w,),
                                                  Text(W_minc[index+1]+'°'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ]
                            ),
                          ),
                          SizedBox(height: 40.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('How to have a good time there?',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Best practice Tips',
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h,),
                          Column(
                            children: [
                              Container(
                                width: 328.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ExpansionTile(
                                    key: GlobalKey(),
                                    onExpansionChanged: (state){
                                    },
                                    iconColor: Colors.black,
                                    collapsedIconColor: Colors.black,
                                    childrenPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    expandedCrossAxisAlignment: CrossAxisAlignment.end,
                                    title: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: 40.sp,
                                              height: 40.sp,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffecd7a8),
                                                  borderRadius: BorderRadius.circular(5.sp)
                                              ),
                                              child: Icon(Icons.free_cancellation_outlined,color: Color(0xff1e1f1f),size: 25.sp,),
                                            ),
                                            instructions[0].state == 'no'?Image(image: AssetImage('assets/disable.png'),height: 40.sp,width: 40.sp,color: Color(0xff1e1f1f),):SizedBox()
                                          ],
                                        ),
                                        SizedBox(width: 8.w,),
                                        Text(instructions[0].name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp
                                          ),),
                                      ],
                                    ),
                                    children: [
                                      Text(instructions[0].content,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp
                                        ),),
                                    ]
                                ),
                              ),
                              SizedBox(height: 10.h,),

                              Container(
                                width: 328.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ExpansionTile(
                                    key: GlobalKey(),
                                    onExpansionChanged: (state){
                                    },
                                    iconColor: Colors.black,
                                    collapsedIconColor: Colors.black,
                                    childrenPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    expandedCrossAxisAlignment: CrossAxisAlignment.end,
                                    title: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: 40.sp,
                                              height: 40.sp,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffecd7a8),
                                                  borderRadius: BorderRadius.circular(5.sp)
                                              ),
                                              child: Icon(Icons.emoji_people_outlined,color: Color(0xff1e1f1f),size: 25.sp,),
                                            ),
                                            instructions[1].state == 'no'?Image(image: AssetImage('assets/disable.png'),height: 40.sp,width: 40.sp,color: Color(0xff1e1f1f),):SizedBox()
                                          ],
                                        ),
                                        SizedBox(width: 8.w,),
                                        Text(instructions[1].name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp
                                          ),),
                                      ],
                                    ),
                                    children: [
                                      Text(instructions[1].content,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp
                                        ),),
                                    ]
                                ),
                              ),
                              SizedBox(height: 10.h,),

                              Container(
                                width: 328.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ExpansionTile(
                                    key: GlobalKey(),
                                    onExpansionChanged: (state){
                                    },
                                    iconColor: Colors.black,
                                    collapsedIconColor: Colors.black,
                                    childrenPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    expandedCrossAxisAlignment: CrossAxisAlignment.end,
                                    title: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: 40.sp,
                                              height: 40.sp,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffecd7a8),
                                                  borderRadius: BorderRadius.circular(5.sp)
                                              ),
                                              child: Icon(Icons.groups_outlined,color: Color(0xff1e1f1f),size: 25.sp,),
                                            ),
                                            instructions[2].state == 'no'?Image(image: AssetImage('assets/disable.png'),height: 40.sp,width: 40.sp,color: Color(0xff1e1f1f),):SizedBox()
                                          ],
                                        ),
                                        SizedBox(width: 8.w,),
                                        Text(instructions[2].name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp
                                          ),),
                                      ],
                                    ),
                                    children: [
                                      Text(instructions[2].content,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp
                                        ),),
                                    ]
                                ),
                              ),
                              SizedBox(height: 10.h,),

                              Container(
                                width: 328.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ExpansionTile(
                                    key: GlobalKey(),
                                    onExpansionChanged: (state){
                                    },
                                    iconColor: Colors.black,
                                    collapsedIconColor: Colors.black,
                                    childrenPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    expandedCrossAxisAlignment: CrossAxisAlignment.end,
                                    title: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: 40.sp,
                                              height: 40.sp,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffecd7a8),
                                                  borderRadius: BorderRadius.circular(5.sp)
                                              ),
                                              child: Icon(Icons.child_care_outlined,color: Color(0xff1e1f1f),size: 25.sp,),
                                            ),
                                            instructions[3].state == 'no'?Image(image: AssetImage('assets/disable.png'),height: 40.sp,width: 40.sp,color: Color(0xff1e1f1f),):SizedBox()
                                          ],
                                        ),
                                        SizedBox(width: 8.w,),
                                        Text(instructions[3].name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp
                                          ),),
                                      ],
                                    ),
                                    children: [
                                      Text(instructions[3].content,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp
                                        ),),
                                    ]
                                ),
                              ),
                              SizedBox(height: 10.h,),

                              Container(
                                width: 328.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ExpansionTile(
                                    key: GlobalKey(),
                                    onExpansionChanged: (state){
                                    },
                                    iconColor: Colors.black,
                                    collapsedIconColor: Colors.black,
                                    childrenPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    expandedCrossAxisAlignment: CrossAxisAlignment.end,
                                    title: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: 40.sp,
                                              height: 40.sp,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffecd7a8),
                                                  borderRadius: BorderRadius.circular(5.sp)
                                              ),
                                              child: Icon(Icons.restaurant_outlined,color: Color(0xff1e1f1f),size: 25.sp,),
                                            ),
                                            instructions[4].state == 'no'?Image(image: AssetImage('assets/disable.png'),height: 40.sp,width: 40.sp,color: Color(0xff1e1f1f),):SizedBox()
                                          ],
                                        ),
                                        SizedBox(width: 8.w,),
                                        Text(instructions[4].name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp
                                          ),),
                                      ],
                                    ),
                                    children: [
                                      Text(instructions[4].content,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp
                                        ),),
                                    ]
                                ),
                              ),
                              SizedBox(height: 10.h,),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  getProgram(context),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            width: 328.w,
                            height: 311.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'It’s a free event!',
                                  style: TextStyle(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Image(
                                    image: AssetImage('assets/ticket.png')),
                                SizedBox(
                                  height: 10.h,
                                ),
                                SizedBox(
                                  width: 250.w,
                                  child: Text(
                                    'You can join the event totally free, with some paid activities.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
          ),
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: 80.h,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                  },
                  child: Container(
                    width: 328.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(64),
                    ),
                    child: Center(
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SecondScreen(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Scheduled activities',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  // InkWell(
                  //   onTap: (){
                  //       if (expands.contains(false)) {
                  //         for(int l = 0; l<programs.length; l++){
                  //           expands[l] = true;
                  //         }
                  //       }else{
                  //         for(int l = 0; l<programs.length; l++){
                  //           expands[l] = false;
                  //         }
                  //       }
                  //   },
                  //   child: Text(expands.contains(false)?'Expand all':'Collapse All',
                  //     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.black),
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: 10.h,),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: programs.length,
                itemBuilder: (context, index) {
                  final prog = programs[index];
                  return Column(
                    children: [
                      Container(
                        width: 328.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ExpansionTile(
                            key: GlobalKey(),
                            initiallyExpanded: expands[index],
                            onExpansionChanged: (value) {
                                expands[index] = value;
                            },
                            iconColor: Colors.black,
                            collapsedIconColor: Colors.black,
                            childrenPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                            expandedCrossAxisAlignment: CrossAxisAlignment.end,
                            title: Row(
                              children: [
                                Container(
                                  constraints:BoxConstraints(
                                    maxWidth: 250.w
                                  ),
                                  child: AutoSizeText(prog.title,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp
                                    ),),
                                ),
                              ],
                            ),
                            children: [
                              Text(prog.content)
                            ]
                        ),
                      ),
                      SizedBox(height: 20.h,),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

}
