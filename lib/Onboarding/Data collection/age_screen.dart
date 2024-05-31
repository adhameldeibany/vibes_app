import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scroll_wheel_date_picker/scroll_wheel_date_picker.dart';
import 'package:vibes/Backend/GlobalMethods.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:vibes/Onboarding/onboarding.dart';

TextEditingController searchcontroller = new TextEditingController();

late Timestamp birth ;

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {

  int selectedValue2 = 0;
  bool a = true;
  bool b = false;

  void _handleRadioValueChange2(int value) {
    setState(() {
      selectedValue2 = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Enter your birthday',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h,),
              SizedBox(
                width: 328.w,
                height: 200.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    color: background,
                    child: ScrollWheelDatePicker(
                      initialDate: DateTime.now(),
                      lastDate: DateTime.now(),
                      startDate: DateTime.utc(DateTime.now().year-100),
                      onSelectedItemChanged: (value) {
                        birth = Timestamp.fromDate(value);
                      },
                      theme: FlatDatePickerTheme(
                        wheelPickerHeight: 200.h,
                        overlay: ScrollWheelDatePickerOverlay.holo,
                        itemTextStyle: defaultItemTextStyle.copyWith(color: Colors.black),
                        overlayColor: Colors.black,
                        overAndUnderCenterOpacity: 0.2,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                ),
              ),
              SizedBox(height: 24.h,),
              InkWell(
                onTap: () async {
                  final ref = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid.toString());
                  await ref.update({'birthdate': birth});
                  GlobalMethods().CheckWhereToGo();
                },
                child: Container(
                  width: 328.w,
                  height: 48.h,
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(child: Text('Create account',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),
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
