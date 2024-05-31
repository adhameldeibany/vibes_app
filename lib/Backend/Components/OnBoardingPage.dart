import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget onBoardingPage({
  required String assetimage,
  required String title,
  required String subtitle
}){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image(
        image: AssetImage(assetimage),
      ),
      SizedBox(height: 40.h,),
      Text(title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 40.sp, color: Colors.black, fontFamily: 'Ogg'),
      ),
      SizedBox(height: 24.h,),
      Text(subtitle,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
      ),
    ],
  );
}