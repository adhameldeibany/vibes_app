import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibes/Auth/auth_screen.dart';
import 'package:vibes/Auth/signup2.dart';
import 'package:vibes/Auth/signup_screen.dart';
import 'package:vibes/Backend/GlobalMethods.dart';
import 'package:vibes/Backend/Models/UserModel.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:vibes/Onboarding/Data%20collection/age_screen.dart';
import 'package:vibes/Onboarding/Data%20collection/nationality_screen.dart';
import 'package:vibes/Onboarding/onboarding.dart';
import 'package:vibes/Profile/profile_screen.dart';
import 'package:vibes/Trips/trips_screen.dart';
import 'package:vibes/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 4),(){
      GlobalMethods().CheckWhereToGo();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondery,
      body: FadeIn(
        duration: Duration(seconds: 3),
        child: Center(
          child: Text('Vibes',
            style: TextStyle(fontSize: 100.sp, fontFamily: 'Ogg'),
          ),
        ),
      ),
    );
  }

}