import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibes/Backend/NavigationPack/VibesNavigator.dart';

Scaffold Vibes_SafeNavHolder({
  required BuildContext Context,
   Color? Background,
  required double NavigationHeight,
  required double OuterNavigationHeight,
  required Widget NavigationBar,
  required Widget activepage,
}){
  return Scaffold(
    backgroundColor: Background == null? Colors.transparent: Background,
    body: Container(
      height: MediaQuery.sizeOf(Context).height + OuterNavigationHeight,
      width: MediaQuery.sizeOf(Context).width,
      color: Colors.transparent,
      child: activepage,
    ),
    extendBody: true,
    bottomNavigationBar: NavigationBar,
  );
}

Widget Vibes_NavigationBar({
  required double NavigationHeight,
  required double OuterNavigationHeight,
  Color? NavigationColor,
  EdgeInsets? padding,
  required Widget FabButton,
  required Widget ChildRight,
  required Widget ChildLeft,
}){
  return Container(
    height: NavigationHeight + OuterNavigationHeight,
    color: Colors.transparent,
    child: Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Padding(
          padding:
          EdgeInsets.only(top: OuterNavigationHeight, ),
          child: Container(
            height: NavigationHeight,
            decoration: BoxDecoration(
              color: NavigationColor == null? Colors.white : NavigationColor,
            ),
            width: double.infinity,
            child: Padding(
                padding: padding == null? EdgeInsets.all(0) : padding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ChildLeft,
                    ChildRight,
                  ],
                )
            ),
          ),
        ),

        FabButton,
      ],
    ),
  );
}

Widget Vibes_IconFab({
  required double FabSize,
  required Icon icon,
  required Color BackgroundColor,
}){
  return Container(
    width: FabSize,
    height: FabSize,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: BackgroundColor,
    ),
    child: Center(
      child: Container(
        child: icon,
      ),
    ),
  );
}

Widget Vibes_ImageFab({
  required double FabSize,
  required ImageProvider imgsrc,
  required Color BackgroundColor,
  required double imgheight,
  required double imgwidth,
}){
  return Container(
    width: FabSize,
    height: FabSize,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: BackgroundColor,
    ),
    child: Center(
      child: Container(
        child: Image(image: imgsrc,height: imgheight,width: imgwidth,),
      ),
    ),
  );
}

Widget Vibes_IconChild({
  required double width,
  required double height,
  required IconData icon,
  required double iconsize,
  required String label,
  required Color ActiveColor,
  required Color NotActiveColor,
  double? labelsize,
  String? labelfontfamily,
  double? spacebetween,
  required bool activecontroller,
}){
  return Container(
    width: width,
    height: height,
    child: Column(
      children: <Widget>[
        Icon(icon,size: iconsize,color: activecontroller?ActiveColor:NotActiveColor,),
        SizedBox(height: spacebetween == null? 6.sp : spacebetween,),
        Text(label, style: TextStyle( fontSize: labelsize == null? 12.sp : labelsize,  color: activecontroller?ActiveColor:NotActiveColor, fontFamily: labelfontfamily == null?'Mohamed Hesham':labelfontfamily),),
      ],
    ),
  );
}

Widget Vibes_ImageChild({
  required double width,
  required double height,
  required ImageProvider imgsrc,
  required double imgsize,
  required String label,
  required Color ActiveColor,
  required Color NotActiveColor,
  double? labelsize,
  String? labelfontfamily,
  double? spacebetween,
  required bool activecontroller,
}){
  return Container(
    width: width,
    height: height,
    child: Column(
      children: <Widget>[
        ClipRRect(
            borderRadius: BorderRadius.circular(666.sp),
            child: Image(image: imgsrc,height: imgsize,width: imgsize,)
        ),
        SizedBox(height: spacebetween == null? 6.sp : spacebetween,),
        Text(label, style: TextStyle( fontSize: labelsize == null? 12.sp : labelsize,  color: activecontroller?ActiveColor:NotActiveColor, fontFamily: labelfontfamily == null?'Mohamed Hesham':labelfontfamily),),
      ],
    ),
  );
}