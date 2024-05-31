import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_machine/time_machine.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibes/Backend/Models/EventModel.dart';
import 'package:vibes/Backend/Models/ExtendedReviewModel.dart';
import 'package:vibes/Backend/Models/InstructionModel.dart';
import 'package:vibes/Backend/Models/ReviewModel.dart';
import 'package:vibes/Backend/Models/UserModel.dart';
import 'package:vibes/Events/minimap.dart';
import 'package:vibes/Events/review_events.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

late EventModel event;
late bool fav;

class EventDetails extends StatefulWidget {
  EventDetails({required EventModel eventModel, required bool Fav}){
    event = eventModel;
    fav = Fav;
  }

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool a = false;
  bool b = false;
  bool s = true;
  bool ex1 = false;
  bool ex2 = false;
  bool ex3 = false;

  final Event even = Event(
    title: event.name,
    description: event.about,
    location: 'Egypt',
    startDate: event.startdate.toDate(),
    endDate: event.enddate.toDate(),
    iosParams: IOSParams(
      reminder: event.enddate.toDate().difference(event.startdate.toDate()), // on iOS, you can set alarm notification after your event.
      url: "http://maps.google.com/maps?&daddr=${event.lat},${event.lon}", // on iOS, you can set url to your event.
    ),
    androidParams: AndroidParams(
      emailInvites: [], // on Android, you can add invite emails to your event.
    ),
  );

  @override
  Widget build(BuildContext context) {
    final dbref = FirebaseDatabase.instance.ref('myevents').child(FirebaseAuth.instance.currentUser!.uid.toString());
    
    return StreamBuilder(
        stream: dbref.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null && (snapshot.data! as DatabaseEvent).snapshot.value != null) {
            final myMessages = Map<dynamic, dynamic>.from((snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>);
            myMessages.forEach((key, value) {
              final currentMessage = Map<String, dynamic>.from(value);
              if(currentMessage['subscribed'] == 'yes' && currentMessage['eventid'] == event.id){
                a = true;
              }else if(currentMessage['subscribed'] == 'no' && currentMessage['eventid'] == event.id){
                a = false;
              }
            });
            return dataScreen(context);
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
            return dataScreen(context);
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
            event.name,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold,),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  if (fav) {
                    FirebaseFirestore.instance.collection("favorites").doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-'+event.id).delete().then(
                          (doc) => print("Document deleted"),
                      onError: (e) => print("Error updating document $e"),
                    );
                  }else{
                    final favevent = <String, String>{
                      "uid": "${FirebaseAuth.instance.currentUser!.uid.toString()}",
                      "eventid": event.id,
                    };

                    FirebaseFirestore.instance
                        .collection("favorites")
                        .doc('${FirebaseAuth.instance.currentUser!.uid.toString()}-'+event.id)
                        .set(favevent)
                        .onError((e, _) => print("Error writing document: $e"));
                  }
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
                                                index==0?event.pic1:index==1?event.pic2:event.pic3,
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    16),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xff0A0A0A00),
                                                    Color(0xff0A0A0A)
                                                  ],
                                                  begin:
                                                  Alignment(0.0, 0.1),
                                                  end: Alignment(0, 1),
                                                )),
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
                  getinstructions(),

                  /*=================================================================================================*/

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

                  /*=================================================================================================*/

                  ReviewStream(),
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
                  onTap: () async{
                    Add2Calendar.addEvent2Cal(even);
                    DatabaseReference ref = FirebaseDatabase.instance.ref('myevents').child('${FirebaseAuth.instance.currentUser!.uid.toString()}').child(event.id);
                    await ref.set({
                      "eventid": event.id,
                      'subscribed':'no'
                    });
                  },
                  child: Container(
                    width: 264.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: bluelight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 24.sp,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          'Add to Calendar',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () async {
                    showToast(a);
                    if (a) {
                      DatabaseReference ref = FirebaseDatabase.instance.ref('myevents').child('${FirebaseAuth.instance.currentUser!.uid.toString()}').child(event.id);
                      await ref.set({
                        "eventid": event.id,
                        'subscribed':'no'
                      });
                      FirebaseMessaging.instance.unsubscribeFromTopic(event.id);
                    }else{
                      DatabaseReference ref = FirebaseDatabase.instance.ref('myevents').child('${FirebaseAuth.instance.currentUser!.uid.toString()}').child(event.id);
                      await ref.set({
                        "eventid": event.id,
                        'subscribed':'yes'
                      });
                      FirebaseMessaging.instance.subscribeToTopic(event.id);
                    }
                  },
                  child: Container(
                    width: 48.sp,
                    height: 48.sp,
                    decoration: BoxDecoration(
                      color: a ? secondery : primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_outlined,
                          size: 24.sp,
                          color: a ? primary : Colors.white,
                        ),
                      ],
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

  void showToast(bool state) => Fluttertoast.showToast(
      msg: state?"Done, Event Is Silenced":"Done, You will get an alert on time",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: primary,
      textColor: Colors.white,
      timeInSecForIosWeb: 1,
      webShowClose: true,
      fontSize: 16.sp
  );


/*======================================== Methods ========================================*/

  ExtendedReviewModel myreview = ExtendedReviewModel(uid: "", msg: "", stars: "", date: Timestamp.fromDate(DateTime.now()),imgurl: "",name: "",id: "");
  List<ReviewModel> reviews = [];
  List<ExtendedReviewModel> users = [];

  int tstars = 0;
  int nstars = 0;
  int n5 = 0;
  int n4 = 0;
  int n3 = 0;
  int n2 = 0;
  int n1 = 0;

  ReviewStream(){
    final ref = FirebaseFirestore.instance.collection('events').doc(event.id).collection('reviews').orderBy('date').snapshots();
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
            myreview = ExtendedReviewModel(uid: "", msg: "", stars: "", date: Timestamp.fromDate(DateTime.now()),imgurl: "",name: "",id: "");
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
              ReviewModel review = new ReviewModel(
                  uid: item['uid'],
                  msg: item['msg'],
                  stars: item['stars'],
                  date: item['date']
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
                        id: ""
                    );
                  }else{
                    ExtendedReviewModel ex = ExtendedReviewModel(
                        uid: rev.uid,
                        msg: rev.msg,
                        stars: rev.stars,
                        date: rev.date,
                        name: item['name'],
                        imgurl: item['imgurl'],
                        id: ""
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
                Get.to(ReviewEvents(Event: event,Fav: fav,));
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
                Get.to(ReviewEvents(Event: event,Fav: fav,));
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
                    Get.to(ReviewEvents(Event: event,Fav: fav,Myreview: myreview,id: myreview.id,));
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
                  Get.to(ReviewEvents(Event: event,Fav: fav,));
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
                  Get.to(ReviewEvents(Event: event,Fav: fav,));
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

  List<InstructionModel> instructions = [];

  getinstructions(){
    final ref = FirebaseFirestore.instance.collection('events').doc(event.id).collection('instructions').orderBy('id').snapshots();
    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            instructions.clear();
            return FirstScreen(context);
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

  FirstScreen(BuildContext context) {
    LocalDate aa = LocalDate(event.startdate.toDate().year, event.startdate.toDate().month, event.startdate.toDate().day);
    LocalDate ab = LocalDate.today();
    Period diff = aa.periodSince(ab);
    print("years: ${diff.years}; months: ${diff.months}; days: ${diff.days}");
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
                      event.about,
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
            SizedBox(
              height: 16.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 160.w,
                  height: 190.h,
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
                            Icon(Icons.calendar_month_outlined, size: 20, color: Colors.black,),
                            SizedBox(width: 5.w,),
                            Text('Date',
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h,),
                        Container(
                          width: 124.w,
                          height: 60.h,
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
                                    Text('From',
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: Colors.grey, fontFamily: 'Avenir'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("${event.startdate.toDate().day}/${event.startdate.toDate().month}/${event.startdate.toDate().year}",
                                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h,),
                        Container(
                          width: 124.w,
                          height: 60.h,
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
                                    Text('To',
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: Colors.grey, fontFamily: 'Avenir'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("${event.enddate.toDate().day}/${event.enddate.toDate().month}/${event.enddate.toDate().year}",
                                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 160.w,
                  height: 190.h,
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
                            Icon(Icons.timer_outlined, size: 20, color: Colors.black,),
                            SizedBox(width: 5.w,),
                            Text('Time',
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h,),
                        Container(
                          width: 124.w,
                          height: 60.h,
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
                                    Text('From',
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: Colors.grey, fontFamily: 'Avenir'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(DateFormat('hh:mm a').format(event.startdate.toDate()),
                                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h,),
                        Container(
                          width: 124.w,
                          height: 60.h,
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
                                    Text('To',
                                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: Colors.grey, fontFamily: 'Avenir'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(DateFormat('hh:mm a').format(event.enddate.toDate()),
                                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 160.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text(event.occur,
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, fontFamily: 'Avenir'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 160.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h,horizontal:8.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text('Starts In',
                              style: TextStyle(fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                            ),
                          ],
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 160.w,
                            minWidth: 160.w,
                          ),
                          child: AutoSizeText(ab.compareTo(aa)>=0?"Already Started": diff.months==0?"${diff.days} Days":"${diff.months} Months ${diff.days} Days",
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, fontFamily: 'Avenir'),
                            maxLines: 1,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
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
                          eventname: event.name,
                          eventdescription: event.about,
                          Latitude:double.parse(event.lat),
                          Longitude:double.parse(event.lon),
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
                                  launchUrl(Uri.parse("http://maps.google.com/maps?&daddr=${event.lat},${event.lon}"));
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
            SizedBox(height: 30.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Instructions',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),
                ),
                // InkWell(
                //   onTap: (){
                //       ex1 = !ex1;
                //       ex2 = !ex2;
                //       ex3 = !ex3;
                //   },
                //   child: Text((ex1 && ex2 && ex3)?'Collapse all':'Expand all',
                //     style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.black),
                //   ),
                // ),
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
                          ex1 = !ex1;
                      },
                      initiallyExpanded: ex1,
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
                        setState(() {
                          ex2 = !ex2;
                        });
                      },
                      initiallyExpanded: ex2,
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
                        setState(() {
                          ex3 = !ex3;
                        });
                      },
                      initiallyExpanded: ex3,
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
                                child: Icon(Icons.checkroom_outlined,color: Color(0xff1e1f1f),size: 25.sp,),
                              ),
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
              ],
            ),
          ],
        ),
      ],
    );
  }

}
