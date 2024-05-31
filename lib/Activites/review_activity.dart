import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:vibes/Activites/activity_details.dart';
import 'package:vibes/Backend/Models/ActivityModel.dart';
import 'package:vibes/Backend/Models/ExtendedReviewModel.dart';
import 'package:vibes/Backend/Models/VendorModel.dart';
import 'package:vibes/Methods/colors_methods.dart';

late ActivityModel act;
late bool fav;
late VendorModel Vendor;
late ExtendedReviewModel myreview;
int x = 0;
String Id = '';
var description = TextEditingController();

class ReviewActivity extends StatefulWidget {
  ReviewActivity({required ActivityModel activityModel,required bool Fav, required VendorModel vendor, ExtendedReviewModel? Myreview, String? id}){
    Vendor = vendor;
    act = activityModel;
    fav = Fav;
    if (Myreview != null) {
      myreview = Myreview;
      description.text = myreview.msg;
      x = int.parse(myreview.stars);
      Id = id!;
    }else{
      description.text = "";
      x = 0;
    }
  }

  @override
  State<ReviewActivity> createState() => _ReviewActivityState();
}

class _ReviewActivityState extends State<ReviewActivity> {

  bool b = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
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
          act.title,
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 328.w,
                height: 490.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Share your experience',
                        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600),
                      ),
                      Image(image: AssetImage('assets/review.png')),
                      Text('Post your experience to the community',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 20.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                x=1;
                              });
                            },
                            child: Transform.scale(
                                scale: x>=1?2.6:1.3,
                                child: x>=1?Image(image: AssetImage('assets/stardark.png', )):Image(image: AssetImage('assets/star.png', ))),
                          ),
                          SizedBox(width: 40.w,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                x=2;
                              });
                            },
                            child: Transform.scale(
                                scale: x>=2?2.6:1.3,
                                child: x>=2?Image(image: AssetImage('assets/stardark.png', )):Image(image: AssetImage('assets/star.png', ))),
                          ),
                          SizedBox(width: 40.w,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                x=3;
                              });
                            },
                            child: Transform.scale(
                                scale: x>=3?2.6:1.3,
                                child: x>=3?Image(image: AssetImage('assets/stardark.png', )):Image(image: AssetImage('assets/star.png', ))),
                          ),
                          SizedBox(width: 40.w,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                x=4;
                              });
                            },
                            child: Transform.scale(
                                scale: x>=4?2.6:1.3,
                                child: x>=4?Image(image: AssetImage('assets/stardark.png', )):Image(image: AssetImage('assets/star.png', ))),
                          ),
                          SizedBox(width: 40.w,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                x=5;
                              });
                            },
                            child: Transform.scale(
                                scale: x>=5?2.6:1.3,
                                child: x>=5?Image(image: AssetImage('assets/stardark.png', )):Image(image: AssetImage('assets/star.png', ))),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h,),
                      Container(
                        width: 280.w,
                        height: 102.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                        ),
                        child: TextFormField(
                          controller: description,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            labelStyle: TextStyle(color: primary, fontSize: 15.sp),
                            hintText: 'Describe your experience',
                            hoverColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 10.sp, fontWeight: FontWeight.w400),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40.h,),
              InkWell(
                onTap: (){
                  String ids = FirebaseFirestore.instance.collection("activitiesreviews").doc().id;
                  final favevent = <String, dynamic>{
                    "uid": "${FirebaseAuth.instance.currentUser!.uid.toString()}",
                    "msg": description.text,
                    "date":Timestamp.fromDate(DateTime.now()),
                    "stars":x.toString(),
                    'actid': act.id,
                    'vendorid':Vendor.id,
                    'id':ids
                  };

                  if (Id != '') {
                    FirebaseFirestore.instance
                        .collection("activitiesreviews")
                        .doc(Id)
                        .update(favevent);
                  }
                  else{
                    FirebaseFirestore.instance.collection("activitiesreviews").doc(ids).set(favevent);
                  }

                  Navigator.pop(context);

                },
                child: Container(
                  width: 328.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(64),
                  ),
                  child: Center(
                    child: Text('Post',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  width: 328.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(64),
                      border: Border.all(color: primary, width: 1.5)
                  ),
                  child: Center(
                    child: Text('Discard',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
