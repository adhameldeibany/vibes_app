import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vibes/Auth/auth_screen.dart';
import 'package:vibes/Auth/signup_screen.dart';
import 'package:vibes/Backend/Models/UserModel.dart';
import 'package:vibes/Home/home_main.dart';
import 'package:vibes/Onboarding/Data%20collection/age_screen.dart';
import 'package:vibes/Onboarding/Data%20collection/nationality_screen.dart';
import 'package:vibes/Onboarding/onboarding.dart';
import 'package:vibes/main.dart';
import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

class GlobalMethods{
  CheckWhereToGo(){
    if (FirebaseAuth.instance.currentUser == null) {
      print("No User Here");
      Get.off(AuthScreen());
    }else{
      final db = FirebaseFirestore.instance;
      final docRef = db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);
      docRef.get().then(
            (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          UserModel user = UserModel(
              uid: data['uid'],
              name: data['name'],
              imgurl: data['imgurl'],
              email: data['email'],
              phone: data['phone'],
              nationality: data['nationality'],
              birthdate: data['birthdate']
          );
          if(user.phone[2] == ''){
            Get.off(SignupScreen(
              User: user,
            ));
          }else if (user.nationality == '') {
            Get.off(NationalityScreen());
          }else if(user.birthdate == Timestamp.fromDate(DateTime.utc(1820,DateTime.november,19))){
            Get.off(AgeScreen());
          }else if(prefs.getBool("onboarding") == null || prefs.getBool("onboarding") == false){
            Get.off(OnboardingScreen());
          }else{
            Get.off(HomeMain());
          }
        },
        onError: (e) => print("Error getting document: $e"),
      );
    }
  }

  double distance(double lat1, double lon1, double lat2, double lon2) {
    const r = 6372.8; // Earth radius in kilometers

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final lat1Radians = _toRadians(lat1);
    final lat2Radians = _toRadians(lat2);

    final a = _haversin(dLat) + cos(lat1Radians) * cos(lat2Radians) * _haversin(dLon);
    final c = 2 * asin(sqrt(a));

    return r * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  num _haversin(double radians) => pow(sin(radians / 2), 2);

}