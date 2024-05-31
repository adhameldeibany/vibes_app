import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibes/Backend/Models/ExtendedReviewModel.dart';
import 'package:vibes/Backend/Models/TripsImageModel.dart';
import 'package:vibes/Backend/Models/TripsModel.dart';
import 'package:vibes/Backend/Models/VendorModel.dart';
import 'package:vibes/Backend/Models/VendorReviewModel.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibes/Trips/review_vendor.dart';
import 'package:vibes/Trips/trips_details.dart';

late VendorModel vendor;

class VendorDetails extends StatefulWidget {
  VendorDetails({required VendorModel Vendor}){
    vendor = Vendor;
  }

  @override
  State<VendorDetails> createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails> {

  bool a = false;
  bool b = false;
  bool s = true;

  @override
  Widget build(BuildContext context) {
    return dataScreen(context);
  }


  // =============================> MH Methods <===================================
  List<TripsImageModel> images = [];

  List<VendorReviewModel> vendorreviews = [];
  List<ExtendedReviewModel> users = [];
  ExtendedReviewModel myreview = ExtendedReviewModel(uid: "", msg: "", stars: "", date: Timestamp.fromDate(DateTime.now()),imgurl: "",name: "",id: "");

  int tstars = 0;
  int nstars = 0;
  int n5 = 0;
  int n4 = 0;
  int n3 = 0;
  int n2 = 0;
  int n1 = 0;

  ReviewStream(){
    final ref = FirebaseFirestore.instance.collection('vendorreviews').where('vendorid',isEqualTo: vendor.id).snapshots();
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
            vendorreviews.clear();
            myreview = ExtendedReviewModel(uid: "", msg: "", stars: "", date: Timestamp.fromDate(DateTime.now()),imgurl: "",name: "",id: "");
            return noreviewsScreen(context);
          }
          else{
            final items = snapshot1.data!.docs;
            vendorreviews.clear();
            tstars = 0;
            nstars = 0;
            n1 = 0;
            n2 = 0;
            n3 = 0;
            n4 = 0;
            n5 = 0;
            for(var item in items){
              VendorReviewModel review = new VendorReviewModel(
                  uid: item['uid'],
                  msg: item['msg'],
                  stars: item['stars'],
                  date: item['date'],
                  vendorid: item['vendorid'],
                  id:item['id']
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
              vendorreviews.add(review);
            }
            return UsersStream(context);
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

  UsersStream(BuildContext context){
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
              for(var rev in vendorreviews){
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
                }
              }
            }
            print(users.length);
            return reviewScreen(context);
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
    final ref = FirebaseFirestore.instance.collection('tripsimages').where('vendorid',isEqualTo: vendor.id).snapshots();
    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            images.clear();
            return mediaScreen(context);
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
            return mediaScreen(context);
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
    var dateTime1 = DateFormat('dd/MM/yyyy').parse(vendor.exprience);
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
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 250.h,
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
                        Row(
                          children: [
                            Container(
                              width: 64.sp,
                              height: 64.sp,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(vendor.imgurl),
                                  )
                              ),
                            ),
                            SizedBox(width: 16.w,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vendor.name),
                                Text('${(DateTime.now().difference(dateTime1).inDays/365.25).toStringAsFixed(0)}+ Years experience'),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h,),
                        Row(
                          children: [
                            Transform.scale(
                                scale: 1.1,
                                child: Image(image: AssetImage('assets/website.png'))),
                            SizedBox(width: 5.w,),
                            Text(vendor.website!),
                          ],
                        ),
                        SizedBox(height: 5.h,),
                        Row(
                          children: [
                            Transform.scale(
                                scale: 1.1,
                                child: Image(image: AssetImage('assets/facebook.png'))),
                            SizedBox(width: 5.w,),
                            Text(vendor.facebook!),
                          ],
                        ),
                        SizedBox(height: 5.h,),
                        Row(
                          children: [
                            Transform.scale(
                                scale: 1.1,
                                child: Image(image: AssetImage('assets/insta.png'))),
                            SizedBox(width: 5.w,),
                            Text(vendor.insta!),
                          ],
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
                    SizedBox(width: 150.w, child: Tab(text: 'Reviews')),
                    SizedBox(width: 150.w, child: Tab(text: 'Trips')),
                    SizedBox(width: 150.w, child: Tab(text: 'Media')),
                  ],
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: TabBarView(
                children: [
                  ReviewStream(),
                  VendorTrips(),
                  getImages(context)
                ]),
          ),
        ),
      ),
    );
  }

  mediaScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 125.h,
                  ),
                  itemCount: images.length,
                  itemBuilder: (_,index){
                    final image = images[index];
                    return Column(
                      children: [
                        Image(image: NetworkImage(image.img)),
                      ],
                    );
                  })
            ],
          ),
        ],
      ),
    );
  }

  reviewScreen(BuildContext context){
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
                Get.to(ReviewVendor(vendor: vendor,));
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
                Get.to(ReviewVendor(vendor: vendor,));
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
                    Get.to(ReviewVendor(vendor: vendor,Myreview: myreview,id: myreview.id));
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

  noreviewsScreen(BuildContext context){
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
                  Get.to(ReviewVendor(vendor: vendor,));
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
                  Get.to(ReviewVendor(vendor: vendor,));
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

  List<TripsModel> trips = [];

  VendorTrips() {
    final ref = FirebaseFirestore.instance.collection('trips').where('vendorid',isEqualTo: vendor.id).snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return getFavs(context);
          }
          else{
            final items = snapshot1.data!.docs;
            trips.clear();
            for(var item in items){

              TripsModel trip = new TripsModel(
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
                cityimg: item['cityimg'],
              );

              trips.add(trip);
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
    final ref = FirebaseFirestore.instance.collection('favorites').where('uid',isEqualTo: '${FirebaseAuth.instance.currentUser!.uid.toString()}-t-').snapshots();
    return StreamBuilder(
        stream: ref,
        builder: (context, snapshot1) {
          if (snapshot1.hasData && snapshot1.data != null ) {
            if (snapshot1.data?.docs.length == 0) {
              Favs.clear();
              return TripsVendorScreen();
            }else{
              Favs.clear();
              final items = snapshot1.data!.docs;
              for(var item in items) {
                Favs.add({
                  "id": item['eventid'],
                  'state': true,
                });
              }
              return TripsVendorScreen();
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

  TripsVendorScreen(){
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 10.h,
        ),
        Container(
          constraints: BoxConstraints(maxHeight: 380.sp),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              bool x = false;
              var y = Favs.where((element) => element['id'] == trip.id).toList();
              if (y.length != 0) {
                x = true;
              }
              return Padding(
                padding: EdgeInsets.only(left: 16.sp),
                child: InkWell(
                  onTap: (){
                    Get.to(TripsDetails(tripsModel: trip, Fav: x,));
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16.sp),
                    width: 242.sp,
                    height: 360.sp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(trip.pic1,),
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
                                    AutoSizeText(trip.from.substring(0,6),
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, color: Colors.white),
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
              );
            },
          ),
        ),
      ],
    );
  }

}
