import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibes/Activites/profile_details.dart';
import 'package:vibes/Activites/review_activity.dart';
import 'package:vibes/Backend/Models/ActivityModel.dart';
import 'package:vibes/Backend/Models/ActivityReviewModel.dart';
import 'package:vibes/Backend/Models/ExtendedReviewModel.dart';
import 'package:vibes/Backend/Models/InstructionModel.dart';
import 'package:vibes/Backend/Models/ProfessionalGuideModel.dart';
import 'package:vibes/Backend/Models/SightsWorkingHours.dart';
import 'package:vibes/Backend/Models/VendorModel.dart';
import 'package:vibes/Events/minimap.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

late ActivityModel activityModel;
late bool fav;
late VendorModel vendorModel;
bool where = false;

class ActivityDetails extends StatefulWidget {
  ActivityDetails({required ActivityModel ActivityModel, required bool Fav, VendorModel? Vendormodel, bool? fromhome}){
    fav = Fav;
    activityModel = ActivityModel;
    if (fromhome != null) {
      where = fromhome;
    }else{
      vendorModel = Vendormodel!;
    }
  }

  @override
  State<ActivityDetails> createState() => _ActivityDetailsState();
}

class _ActivityDetailsState extends State<ActivityDetails> {
  bool a = false;
  bool b = false;
  bool s = true;

  @override
  Widget build(BuildContext context) {
    return where? getVendor(context) : dataScreen(context);
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

  // =============================================================================> Method <=============================================================================

  getVendor(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('vendors').doc(activityModel.vendorid).snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data! == null) {
            return Placeholder();
          }
          else{
            final item = snapshot1.data!;
            vendorModel = new VendorModel(
                id: item['id'],
                name: item['name'],
                exprience: item['Experience'],
                imgurl: item['imgurl']
            );
            return dataScreen(context);
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

  dataScreen(BuildContext context){
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
            activityModel.title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          actions: [
            InkWell(
              onTap: () {
                if (fav) {
                  FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-a-'+activityModel.id).delete().then(
                        (doc) => print("Document deleted"),
                    onError: (e) => print("Error updating document $e"),
                  );
                }else{
                  final favevent = <String, String>{
                    "uid": "${FirebaseAuth.instance.currentUser!.uid.toString()}-a-",
                    "eventid": activityModel.id,
                  };

                  FirebaseFirestore.instance
                      .collection("favorites")
                      .doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-a-'+activityModel.id)
                      .set(favevent)
                      .onError((e, _) => print("Error writing document: $e"));
                }
                setState(() {
                  fav = !fav;
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
                      fav ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart, color: fav ? Colors.black : Colors.black,
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
                                                index==0?activityModel.pic1:index==1?activityModel.pic2:activityModel.pic3,
                                              ),
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
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16.sp),
                  tabs: [
                    SizedBox(width: 150.w, child: Tab(text: 'Details')),
                    SizedBox(width: 150.w, child: Tab(text: 'Tickets')),
                    SizedBox(width: 150.w, child: Tab(text: 'Reviews')),
                  ],
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, top: 10),
            child: TabBarView(
                children: [
                  getProfessionalGuide(context),
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
                  ReviewStream()
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
                  onTap: (){
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
                        'Label',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
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

  late ProfessionalGuideModel pgm;

  getProfessionalGuide(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('professional guides').snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return Placeholder();
          }
          else{
            final items = snapshot1.data!.docs;
            for(var item in items){
              if (item['id'] == activityModel.professionalguideid) {
                pgm = new ProfessionalGuideModel(
                    id: item['id'],
                    name: item['name'],
                    imgurl: item['imgurl']
                );
                break;
              }
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

  int vendor_tstars = 0;
  int vendor_nstars = 0;
  getVendorReview(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('activitiesreviews').where('vendorid',isEqualTo: activityModel.vendorid).snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            print('No Reviews');
            return getcaterings(context);
          }
          else{

            vendor_tstars = 0;
            vendor_nstars = 0;
            final items = snapshot1.data!.docs;
            for(var item in items){
              vendor_tstars += int.parse(item['stars']);
              vendor_nstars +=1;
            }
            return getcaterings(context);
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

  List<InstructionModel> instructions = [];

  List<String> caterings = [];
  List<String> gears = [];

  getinstructions(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('activities').doc(activityModel.id).collection('instructions').orderBy('id').snapshots();
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
            return getVendorReview(context);
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

  getcaterings(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('activities').doc(activityModel.id).collection('caterings').snapshots();
    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            caterings.clear();
            return getgears(context);
          }
          else{
            final items = snapshot1.data!.docs;
            caterings.clear();
            for(var item in items){
              caterings.add(item['name']);
            }
            return getgears(context);
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

  getgears(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('activities').doc(activityModel.id).collection('gears').snapshots();
    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            gears.clear();
            return GetWorkingHours(context);
          }
          else{
            final items = snapshot1.data!.docs;
            gears.clear();
            for(var item in items){
              gears.add(item['name']);
            }
            return GetWorkingHours(context);
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

  List<String> weekedt = ['','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];

  String getdow(){
    DateTime now = DateTime.now();
    return weekedt[now.weekday];
  }

  List<SightWorkingHoursModel> workinghours = [];
  List<String> days = [];

  Map<String,List<SightWorkingHoursModel>> workhours = {};

  GetWorkingHours(BuildContext context) {

    final ref = FirebaseFirestore.instance.collection('activities').doc(activityModel.id)
        .collection('working hours').orderBy('id').snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return FirstScreen(context);
          }
          else{
            workinghours.clear();
            days.clear();
            final items = snapshot1.data!.docs;
            for(var item in items){
              workinghours.add(
                  SightWorkingHoursModel(
                      title: item['title'],
                      from: item['from'],
                      to: item['to']
                  )
              );
              if (item['title'] == 'Everyday') {
                days.add(weekedt[1]);
                days.add(weekedt[2]);
                days.add(weekedt[3]);
                days.add(weekedt[4]);
                days.add(weekedt[5]);
                days.add(weekedt[6]);
                days.add(weekedt[7]);
              }else if(item['title'] == 'Sun : Thu'){
                days.add(weekedt[7]);
                days.add(weekedt[1]);
                days.add(weekedt[2]);
                days.add(weekedt[3]);
                days.add(weekedt[4]);
              }else if(item['title'] == 'Fri : Sat'){
                days.add(weekedt[5]);
                days.add(weekedt[6]);
              }else{
                days.add(item['title']);
              }
            }

            workhours = groupBy(workinghours, (SightWorkingHoursModel obj) => obj.title);

            return FirstScreen(context);
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


  ExtendedReviewModel myreview = ExtendedReviewModel(uid: "", msg: "", stars: "", date: Timestamp.fromDate(DateTime.now()),imgurl: "",name: "", id: "");
  List<ActivityReviewModel> reviews = [];
  List<ExtendedReviewModel> users = [];

  int tstars = 0;
  int nstars = 0;
  int n5 = 0;
  int n4 = 0;
  int n3 = 0;
  int n2 = 0;
  int n1 = 0;

  UsersStream(){
    final ref = FirebaseFirestore.instance.collection('users').snapshots();
    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return Placeholder();
          }
          else{
            final items = snapshot1.data!.docs;
            users.clear();
            for(var item in items){
              for(var rev in reviews){
                if (rev.uid == item['uid']) {
                  if (rev.uid == "${FirebaseAuth.instance.currentUser!.uid.toString()}") {
                    myreview = ExtendedReviewModel(
                        uid: rev.uid,
                        msg: rev.msg,
                        stars: rev.stars,
                        date: rev.date,
                        imgurl: item['imgurl'],
                        name: item['name'],
                        id: rev.id
                    );
                  }else{
                    ExtendedReviewModel ex = ExtendedReviewModel(
                        uid: rev.uid,
                        msg: rev.msg,
                        stars: rev.stars,
                        date: rev.date,
                        name: item['name'],
                        imgurl: item['imgurl'],
                        id: rev.id
                    );
                    users.add(ex);
                  }
                  break;
                }
              }
            }
            print(users.length);
            return reviewScreen();
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

  ReviewStream(){
    final ref = FirebaseFirestore.instance.collection('activitiesreviews')
        .where('actid',isEqualTo: activityModel.id).snapshots();
    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            tstars = 0;
            nstars = 0;
            n1 = 0;
            n2 = 0;
            n3 = 0;
            n4 = 0;
            n5 = 0;
            reviews.clear();
            myreview = ExtendedReviewModel(uid: "", msg: "", stars: "", date: Timestamp.fromDate(DateTime.now()),imgurl: "",name: "", id: "");
            return noreviewsScreen();
          }
          else{
            final items = snapshot1.data!.docs;
            reviews.clear();
            tstars = 0;
            nstars = 0;
            n1 = 0;
            n2 = 0;
            n3 = 0;
            n4 = 0;
            n5 = 0;
            for(var item in items){
              ActivityReviewModel review = new ActivityReviewModel(
                  uid: item['uid'],
                  msg: item['msg'],
                  stars: item['stars'],
                  date: item['date'],
                  actid: item['actid'],
                  vendorid: item['vendorid'],
                  id: item['id'],
              );
              tstars += int.parse(review.stars);
              if (int.parse(review.stars) == 5) {
                n5 +=1;
              }else if (int.parse(review.stars) == 4) {
                n4 +=1;
              }else if (int.parse(review.stars) == 3) {
                n3 +=1;
              }else if (int.parse(review.stars) == 2) {
                n2 +=1;
              }else{
                n1 +=1;
              }
              nstars +=1;
              reviews.add(review);
            }
            return UsersStream();
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

  reviewScreen(){
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Column(
          children: [
            SizedBox(height: 10.h,),
            Text('Share your experience',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16.sp),
            ),
            SizedBox(height: 10.h,),
            myreview.uid != ""?SizedBox():InkWell(
              onTap:(){
                Get.to(ReviewActivity(activityModel: activityModel, Fav: fav, vendor: vendorModel));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                      scale: 1.3,
                      child: Image(image: AssetImage('assets/star.png', ))),
                  SizedBox(width: 40.w,),
                  Transform.scale(
                      scale: 1.3,
                      child: Image(image: AssetImage('assets/star.png', ))),
                  SizedBox(width: 40.w,),
                  Transform.scale(
                      scale: 1.3,
                      child: Image(image: AssetImage('assets/star.png', ))),
                  SizedBox(width: 40.w,),
                  Transform.scale(
                      scale: 1.3,
                      child: Image(image: AssetImage('assets/star.png', ))),
                  SizedBox(width: 40.w,),
                  Transform.scale(
                      scale: 1.3,
                      child: Image(image: AssetImage('assets/star.png', ))),
                ],
              ),
            ),
            myreview.uid != ""?SizedBox():SizedBox(height: 20.h,),
            myreview.uid != ""?SizedBox():InkWell(
              onTap: (){
                Get.to(ReviewActivity(activityModel: activityModel, Fav: fav, vendor: vendorModel));
              },
              child: Text('Write a review',
                style: TextStyle(color: primary, fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 10.h,),
            myreview.uid != ""? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your reviews',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                TextButton(
                  onPressed: (){
                    Get.to(ReviewActivity(activityModel: activityModel, Fav: fav, vendor: vendorModel,Myreview: myreview,id: myreview.id,));
                  },
                  child: Text('Edit',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: primary),
                  ),
                ),
              ],
            ):SizedBox(),
            myreview.uid != ""? Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                  border: Border.all(color: primary, width: 2.w),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(myreview.imgurl),
                                  )
                              ),
                            ),
                            SizedBox(width: 8.w,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 120.w,
                                  child: AutoSizeText(myreview.name,
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                          scale: int.parse(myreview.stars)>=1?1.3:0.7,
                                          child: int.parse(myreview.stars)>=1?Image(image: AssetImage('assets/stardark.png', )):Image(image: AssetImage('assets/star.png', ))
                                      ),
                                      SizedBox(width: 8.w,),
                                      Transform.scale(
                                          scale: int.parse(myreview.stars)>=2?1.3:0.7,
                                          child: int.parse(myreview.stars)>=2?Image(image: AssetImage('assets/stardark.png', )):Image(image: AssetImage('assets/star.png', ))
                                      ),
                                      SizedBox(width: 8.w,),
                                      Transform.scale(
                                          scale: int.parse(myreview.stars)>=3?1.3:0.7,
                                          child: int.parse(myreview.stars)>=3?Image(image: AssetImage('assets/stardark.png', )):Image(image: AssetImage('assets/star.png', ))
                                      ),
                                      SizedBox(width: 8.w,),
                                      Transform.scale(
                                          scale: int.parse(myreview.stars)>=4?1.3:0.7,
                                          child: int.parse(myreview.stars)>=4?Image(image: AssetImage('assets/stardark.png', )):Image(image: AssetImage('assets/star.png', ))
                                      ),
                                      SizedBox(width: 5.w,),
                                      Transform.scale(
                                          scale: int.parse(myreview.stars)>=5?1.3:0.7,
                                          child: int.parse(myreview.stars)>=5?Image(image: AssetImage('assets/stardark.png', )):Image(image: AssetImage('assets/star.png', ))
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(myreview.date.toDate().toString().substring(0,10),
                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h,),
                    ReadMoreText(myreview.msg,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 10.sp),
                      trimLines: 2,
                      colorClickableText: Colors.black,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Read more',
                      trimExpandedText: 'Read less',
                      moreStyle: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: primary,
                      ),
                      lessStyle: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: primary,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ):SizedBox(),
            SizedBox(height: 15.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text('5',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                        LinearPercentIndicator(
                          animation: true,
                          barRadius: Radius.circular(20),
                          animationDuration: 3000,
                          width: 200.w,
                          lineHeight: 5.h,
                          percent: (n5/nstars),
                          progressColor: primary,
                          backgroundColor: secondery,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('4',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                        LinearPercentIndicator(
                          animation: true,
                          barRadius: Radius.circular(20),
                          animationDuration: 3000,
                          width: 200.w,
                          lineHeight: 5.h,
                          percent: (n4/nstars),
                          progressColor: primary,
                          backgroundColor: secondery,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('3',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                        LinearPercentIndicator(
                          animation: true,
                          barRadius: Radius.circular(20),
                          animationDuration: 3000,
                          width: 200.w,
                          lineHeight: 5.h,
                          percent: (n3/nstars),
                          progressColor: primary,
                          backgroundColor: secondery,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('2',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                        LinearPercentIndicator(
                          animation: true,
                          barRadius: Radius.circular(20),
                          animationDuration: 3000,
                          width: 200.w,
                          lineHeight: 5.h,
                          percent: (n2/nstars),
                          progressColor: primary,
                          backgroundColor: secondery,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('1',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                        LinearPercentIndicator(
                          animation: true,
                          barRadius: Radius.circular(20),
                          animationDuration: 3000,
                          width: 200.w,
                          lineHeight: 5.h,
                          percent: (n1/nstars),
                          progressColor: primary,
                          backgroundColor: secondery,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text((tstars.toDouble()/nstars.toDouble()).toStringAsFixed(2),
                      style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Transform.scale(
                            scale:  (tstars/nstars)>0?(tstars/nstars)>=1?1:0.7:1,
                            child: (tstars/nstars)>0?(tstars/nstars)>=1?Image(image: AssetImage('assets/starlight.png', ))
                                :Image(image: AssetImage('assets/halfstar.png', ))
                                :Image(image: AssetImage('assets/stargrey.png', ))
                        ),
                        SizedBox(width: 5.w,),
                        Transform.scale(
                            scale:  (tstars/nstars)>1?(tstars/nstars)>=2?1:0.7:1,
                            child: (tstars/nstars)>1?(tstars/nstars)>=2?Image(image: AssetImage('assets/starlight.png', ))
                                :Image(image: AssetImage('assets/halfstar.png', ))
                                :Image(image: AssetImage('assets/stargrey.png', ))
                        ),
                        SizedBox(width: 5.w,),
                        Transform.scale(
                            scale:  (tstars/nstars)>2?(tstars/nstars)>=3?1:0.7:1,
                            child: (tstars/nstars)>2?(tstars/nstars)>=3?Image(image: AssetImage('assets/starlight.png', ))
                                :Image(image: AssetImage('assets/halfstar.png', ))
                                :Image(image: AssetImage('assets/stargrey.png', ))
                        ),
                        SizedBox(width: 5.w,),
                        Transform.scale(
                            scale: (tstars/nstars)>3?(tstars/nstars)>=4?1:0.7:1,
                            child: (tstars/nstars)>3?(tstars/nstars)>=4?Image(image: AssetImage('assets/starlight.png', ))
                                :Image(image: AssetImage('assets/halfstar.png', ))
                                :Image(image: AssetImage('assets/stargrey.png', ))
                        ),
                        SizedBox(width: 5.w,),
                        Transform.scale(
                            scale: (tstars/nstars)>4?(tstars/nstars)>=5?1:0.7:1,
                            child: (tstars/nstars)>4?(tstars/nstars)>=5?Image(image: AssetImage('assets/starlight.png', ))
                                :Image(image: AssetImage('assets/halfstar.png', ))
                                :Image(image: AssetImage('assets/stargrey.png', ))
                        ),
                      ],
                    ),
                    Text(nstars.toString(),
                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30.h,),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final review = users[index];
                  int rate = int.parse(review.stars);
                  return Column(
                    children: [
                      Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 24.w,
                                        height: 24.h,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: primary, width: 2.w),
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(review.imgurl),
                                            )
                                        ),
                                      ),
                                      SizedBox(width: 8.w,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 120.w,
                                            child: AutoSizeText(review.name,
                                              maxLines: 2,
                                              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 15),
                                            child: Row(
                                              children: [
                                                Transform.scale(
                                                    scale:rate>=1? 1.3:0.7,
                                                    child: rate>=1?Image(image: AssetImage('assets/stardark.png', ))
                                                        :Image(image: AssetImage('assets/star.png', ))
                                                ),
                                                SizedBox(width: 8.w,),
                                                Transform.scale(
                                                    scale: rate>=2?1.3:0.7,
                                                    child: rate>=2?Image(image: AssetImage('assets/stardark.png', ))
                                                        :Image(image: AssetImage('assets/star.png', ))
                                                ),
                                                SizedBox(width: 8.w,),
                                                Transform.scale(
                                                    scale: rate>=3?1.3:0.7,
                                                    child: rate>=3?Image(image: AssetImage('assets/stardark.png', ))
                                                        :Image(image: AssetImage('assets/star.png', ))
                                                ),
                                                SizedBox(width: 8.w,),
                                                Transform.scale(
                                                    scale: rate>=4?1.3:0.7,
                                                    child: rate>=4?Image(image: AssetImage('assets/stardark.png', ))
                                                        :Image(image: AssetImage('assets/star.png', ))
                                                ),
                                                SizedBox(width: 5.w,),
                                                Transform.scale(
                                                    scale: rate>=5?1.3:0.7,
                                                    child: rate>=5?Image(image: AssetImage('assets/stardark.png', ))
                                                        :Image(image: AssetImage('assets/star.png', ))
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(review.date.toDate().toString().substring(0,10),
                                    style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h,),
                              ReadMoreText(review.msg,
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 10.sp),
                                trimLines: 2,
                                colorClickableText: Colors.black,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Read more',
                                trimExpandedText: 'Read less',
                                moreStyle: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: primary,
                                ),
                                lessStyle: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: primary,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h,),
                    ],
                  );
                }),
          ],
        ),
      ],
    );
  }

  noreviewsScreen(){
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No reviews yet',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
              ),
              SizedBox(height: 20.h,),
              Text('Share your experience',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 30.h,),
              InkWell(
                onTap:(){
                  Get.to(ReviewActivity(activityModel: activityModel, Fav: fav, vendor: vendorModel));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                        scale: 1.3,
                        child: Image(image: AssetImage('assets/star.png', ))),
                    SizedBox(width: 40.w,),
                    Transform.scale(
                        scale: 1.3,
                        child: Image(image: AssetImage('assets/star.png', ))),
                    SizedBox(width: 40.w,),
                    Transform.scale(
                        scale: 1.3,
                        child: Image(image: AssetImage('assets/star.png', ))),
                    SizedBox(width: 40.w,),
                    Transform.scale(
                        scale: 1.3,
                        child: Image(image: AssetImage('assets/star.png', ))),
                    SizedBox(width: 40.w,),
                    Transform.scale(
                        scale: 1.3,
                        child: Image(image: AssetImage('assets/star.png', ))),
                  ],
                ),
              ),
              SizedBox(height: 35.h,),
              InkWell(
                onTap: () {
                  Get.to(ReviewActivity(activityModel: activityModel, Fav: fav, vendor: vendorModel));
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
                      'Write a review',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'Avenir'
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  FirstScreen(BuildContext context){
    return ListView(
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
                      activityModel.about,
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
                            Get.to(ProfileDetails(
                              Vendor: vendorModel,
                              nRating: vendor_nstars,
                              tRating: vendor_tstars,
                            ));
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
                                    image: NetworkImage(vendorModel.imgurl),
                                  )
                              ),
                            ),
                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: 120.w,
                              child: AutoSizeText(vendorModel.name,
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
                                  (vendor_tstars/vendor_nstars) >=1?
                                  Image(image: AssetImage('assets/stargrey.png', ))
                                      :(vendor_tstars/vendor_nstars) >=0?Image(image: AssetImage('assets/starhalfgrey.png', ))
                                      :Image(image: AssetImage('assets/star.png',),color: Color(0xffACACAC),height: 12.sp,width: 12.sp,),
                                  SizedBox(width: 3.w,),
                                  (vendor_tstars/vendor_nstars) >=2?
                                  Image(image: AssetImage('assets/stargrey.png', ))
                                      :(vendor_tstars/vendor_nstars) >=1?Image(image: AssetImage('assets/starhalfgrey.png', ))
                                      :Image(image: AssetImage('assets/star.png',),color: Color(0xffACACAC),height: 12.sp,width: 12.sp,),
                                  SizedBox(width: 3.w,),
                                  (vendor_tstars/vendor_nstars) >=3?
                                  Image(image: AssetImage('assets/stargrey.png', ))
                                      :(vendor_tstars/vendor_nstars) >=2?Image(image: AssetImage('assets/starhalfgrey.png', ))
                                      :Image(image: AssetImage('assets/star.png',),color: Color(0xffACACAC),height: 12.sp,width: 12.sp,),
                                  SizedBox(width: 3.w,),
                                  (vendor_tstars/vendor_nstars) >=4?
                                  Image(image: AssetImage('assets/stargrey.png', ))
                                      :(vendor_tstars/vendor_nstars) >=3?Image(image: AssetImage('assets/starhalfgrey.png', ))
                                      :Image(image: AssetImage('assets/star.png',),color: Color(0xffACACAC),height: 12.sp,width: 12.sp,),
                                  SizedBox(width: 3.w,),
                                  (vendor_tstars/vendor_nstars) >=5?
                                  Image(image: AssetImage('assets/stargrey.png', ))
                                      :(vendor_tstars/vendor_nstars) >=4?Image(image: AssetImage('assets/starhalfgrey.png', ))
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
              width: 328.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
              ),
              child: ExpansionTile(
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                  collapsedIconColor: Colors.black,
                  childrenPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  expandedCrossAxisAlignment: CrossAxisAlignment.end,
                  title: Row(
                    children: [
                      Text('Included',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp
                        ),),
                    ],
                  ),
                  children: [
                    Container(
                      width: 296.sp,
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text('Transportation',
                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pick up:',
                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, fontFamily: 'Avenir'),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 200.w
                                  ),
                                  child: Text(activityModel.pickfrom,
                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h,),
                    Container(
                      width: 296.sp,
                      height: 60.sp,
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Professional Guide',
                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                                ),
                                Container(
                                  width: 24.sp,
                                  height: 24.sp,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(pgm.imgurl),
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h,),
                    Container(
                      width: 296.w,
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text('Catering:',
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.sp,),
                            Container(
                              width: 296.w,
                              child: Wrap(
                                children: List.generate(
                                  caterings.length,
                                      (index) {
                                    final catering = caterings[index];
                                    return Container(
                                      margin: EdgeInsets.all(8.sp),
                                      padding: EdgeInsets.all(12.sp),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Wrap(
                                        children: [Transform.scale(
                                          scale: 1.1,
                                          child: Text(catering,
                                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, fontFamily: 'Avenir',),
                                          ),
                                        ),],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h,),
                    Container(
                      width: 296.w,
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text('Gear:',
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.sp,),
                            Container(
                              width: 296.w,
                              child: Wrap(
                                children: List.generate(
                                  gears.length,
                                      (index) {
                                    final gear = gears[index];
                                    return Container(
                                      margin: EdgeInsets.all(8.sp),
                                      padding: EdgeInsets.all(12.sp),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Wrap(
                                        children: [Transform.scale(
                                          scale: 1.1,
                                          child: Text(gear,
                                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, fontFamily: 'Avenir',),
                                          ),
                                        ),],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Container(
              width: 328.w,
              height: 260.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Requirements',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: 'Avenir'),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h,),
                    Container(
                      width: 296.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Age',
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, fontFamily: 'Avenir'),
                            ),
                            Text(activityModel.age,
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h,),
                    Container(
                      width: 296.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('ID',
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, fontFamily: 'Avenir'),
                            ),
                            Text(activityModel.ID,
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h,),
                    Container(
                      width: 296.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Dress Code',
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, fontFamily: 'Avenir'),
                            ),
                            Text(activityModel.dresscode,
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Container(
              width: 328.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 20.sp, color: Colors.black,),
                            SizedBox(width: 5.sp,),
                            Text('Working times',
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: 'Avenir'),
                            ),
                          ],
                        ),
                        Container(
                          width: 91.sp,
                          height: 24.sp,
                          decoration: BoxDecoration(
                            color: days.contains(getdow()) ?Color(0xffE3FFE2):Color(0xffFF6767).withOpacity(0.25),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text( days.contains(getdow()) ?'Open Today': 'Closed',
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: days.contains(getdow()) ? Color(0xff008A1E):Color(0xffff0000),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.sp,),
                    Container(
                      width: 328.sp,
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: workhours.keys.toList().length,
                                itemBuilder: (context, index) {
                                  final work = workhours.keys.toList()[index];
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(work,
                                            style: TextStyle(fontSize: 14.sp, fontFamily: 'Avenir', fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.sp,),
                                      Container(
                                        width: 328.w,
                                        child: Wrap(
                                          children: List.generate(
                                                workhours[work]!.length,
                                                    (index2) {
                                                  final fr = workhours[work]![index2].from;
                                                  return Container(
                                                    margin: EdgeInsets.all(8.sp),
                                                    padding: EdgeInsets.all(8.sp),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(4)
                                                    ),
                                                    child: Wrap(
                                                      children: [
                                                        Text(fr,
                                                          style: TextStyle(fontSize: 14.sp, fontFamily: 'Avenir'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                        ),
                                      )
                                    ],
                                  );

                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h,),
            Container(
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
                          eventname: activityModel.title,
                          eventdescription: activityModel.about,
                          Latitude:double.parse(activityModel.lat),
                          Longitude:double.parse(activityModel.lon),
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
                                  launchUrl(Uri.parse("http://maps.google.com/maps?&daddr=${activityModel.lat},${activityModel.lon}"));
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
            SizedBox(height: 24.h,),
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
    );
  }

}
