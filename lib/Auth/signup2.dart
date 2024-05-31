import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vibes/Auth/auth_screen.dart';
import 'package:vibes/Auth/login_screen.dart';
import 'package:vibes/Auth/signup_screen.dart';
import 'package:vibes/Backend/GlobalMethods.dart';
import 'package:vibes/Backend/Models/UserModel.dart';
import 'package:vibes/Methods/colors_methods.dart';

class Signup2 extends StatefulWidget {
  const Signup2({super.key});

  @override
  State<Signup2> createState() => _Signup2State();
}

class _Signup2State extends State<Signup2> {

  var emailcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Get.off(AuthScreen());
        return false;
      },
      child: Scaffold(
        backgroundColor: background,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h,),
                  Text(
                    'Create new account',
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 90.h,),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email", style: TextStyle(fontSize: 14.sp)),
                        ],
                      ),
                      SizedBox(height: 10.h,),
                      SizedBox(
                        height: 50.h,
                        width: 328.w,
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.black),
                          controller: emailcontroller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,)),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primary,width: 2.w)),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h,),
                      InkWell(
                        onTap: ()  {
                          if (emailcontroller.text.length == 0) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: "E-mail Can't Be Empty !",
                            );
                          }else{
                            Get.to(SignupScreen(
                              User: UserModel(
                                  uid: '',
                                  name: '',
                                  imgurl: '',
                                  email: emailcontroller.text,
                                  phone: ['','',''],
                                  nationality: '',
                                  birthdate: Timestamp.fromDate(DateTime.utc(1820,DateTime.november,19))
                              ),
                            )
                            );
                          }
                        },
                        child: Container(
                          width: 328.w,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Continue",
                                style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 48.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 0.3.h,
                              width: MediaQuery.of(context).size.width/2.5,
                              child: Divider(color: Colors.grey)
                          ),
                          SizedBox(width: 10.w,),
                          Text('Or'),
                          SizedBox(width: 10.w,),
                          SizedBox(
                            height: 0.3.h,
                              width: MediaQuery.of(context).size.width/2.5,
                              child: Divider(color: Colors.grey)
                          ),
                        ],
                      ),
                      SizedBox(height: 48.h,),
                      InkWell(
                        onTap: () async {
                          await signInWithGoogle(context);
                        },
                        child: Container(
                            width: 328.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.grey)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                    width: 20.w,
                                    height: 20.h,
                                    image: AssetImage('assets/google.png')),
                                SizedBox(width: 8.w,),
                                Text("Continue With Google",
                                  style: TextStyle(color: Colors.black, fontSize: 16.sp,fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 24.h,),
                      InkWell(
                        onTap: () async {
                          await signInWithApple();
                        },
                        child: Container(
                            width: 328.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.grey)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.scale(
                                  scale: 2.5,
                                  child: Image(
                                      width: 20.w,
                                      height: 20.h,
                                      image: AssetImage('assets/apple.png')),
                                ),
                                SizedBox(width: 8.w,),
                                Text("Continue With Apple",
                                  style: TextStyle(color: Colors.black, fontSize: 16.sp,fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 24.h,),
                      InkWell(
                        onTap: () async {
                          await SignInWithTwitter();
                        },
                        child: Container(
                            width: 328.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.grey)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.scale(
                                  scale: 2.1,
                                  child: Image(
                                      width: 20.w,
                                      height: 20.h,
                                      image: AssetImage('assets/X.png')),
                                ),
                                SizedBox(width: 8.w,),
                                Text("Continue With X",
                                  style: TextStyle(color: Colors.black, fontSize: 16.sp,fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 5.w,),
                      InkWell(
                        onTap: (){
                          Get.off(LoginScreen());
                        },
                        child: Text("Log in",
                          style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================================> Auth Methods <=========================================================================================

  signInWithGoogle(BuildContext context) async{

    final GoogleSignInAccount? guser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gauth = await guser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: gauth.accessToken,
        idToken: gauth.idToken
    );

    await  FirebaseAuth.instance.signInWithCredential(credential);

    if (await checkIfDocExists(FirebaseAuth.instance.currentUser!.uid.toString())) {
      GlobalMethods().CheckWhereToGo();
    }else{
      final user = <String, dynamic>{
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "name": guser.displayName,
        "email": guser.email,
        "imgurl": guser.photoUrl==null?'https://firebasestorage.googleapis.com/v0/b/flocker-vibes.appspot.com/o/users%2Fuser2.jpg?alt=media&token=2dec32b9-e490-49a4-974d-51fc5caa73e5':guser.photoUrl,
        'phone': ['','',''],
        'nationality':'',
        'birthdate':Timestamp.fromDate(DateTime.utc(1820,DateTime.november,19)),
      };

      await FirebaseFirestore
          .instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(user)
          .onError((e, _) => print("Error writing document: $e"));

      GlobalMethods().CheckWhereToGo();

    }
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');

      var docm = await collectionRef.doc(docId).get();
      return docm.exists;
    } catch (e) {
      throw e;
    }
  }

  Future SignInWithTwitter() async{
    TwitterAuthProvider twitterProvider = TwitterAuthProvider();

    UserCredential use;

    if (kIsWeb) {
      use = await FirebaseAuth.instance.signInWithPopup(twitterProvider);
      if(await checkIfDocExists(FirebaseAuth.instance.currentUser!.uid.toString())){
        GlobalMethods().CheckWhereToGo();
      }
      else{
        final user = <String, dynamic>{
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "name": use.user!.displayName,
          "email": use.user!.email,
          "imgurl": use.user?.photoURL==null?'https://firebasestorage.googleapis.com/v0/b/flocker-vibes.appspot.com/o/users%2Fuser2.jpg?alt=media&token=2dec32b9-e490-49a4-974d-51fc5caa73e5':use.user!.photoURL,
          'phone': ['','',''],
          'nationality':'',
          'birthdate':Timestamp.fromDate(DateTime.utc(1820,DateTime.november,19)),
        };

        await FirebaseFirestore
            .instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(user)
            .onError((e, _) => print("Error writing document: $e"));

        GlobalMethods().CheckWhereToGo();

      }
    } else {
      use = await FirebaseAuth.instance.signInWithProvider(twitterProvider);
      if(await checkIfDocExists(FirebaseAuth.instance.currentUser!.uid.toString())){
        GlobalMethods().CheckWhereToGo();
      }
      else{
        final user = <String, dynamic>{
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "name": use.user!.displayName,
          "email": use.user!.email,
          "imgurl": use.user!.photoURL,
          'phone': ['','',''],
          'nationality':'',
          'birthdate':Timestamp.fromDate(DateTime.utc(1820,DateTime.november,19)),
        };

        await FirebaseFirestore
            .instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(user)
            .onError((e, _) => print("Error writing document: $e"));

        GlobalMethods().CheckWhereToGo();

      }

    }

  }

  Future signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(appleProvider);
    String? authCode = userCredential.additionalUserInfo?.authorizationCode;
    final user = <String, dynamic>{
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "name": userCredential.user!.displayName,
      "email": userCredential.user!.email,
      "imgurl": userCredential.user!.photoURL,
      'phone': ['','',userCredential.user!.phoneNumber],
      'nationality': '',
      'birthdate':Timestamp.fromDate(DateTime.utc(1820,DateTime.november,19)),
    };

    await FirebaseFirestore
        .instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(user)
        .onError((e, _) => print("Error writing document: $e"));

    GlobalMethods().CheckWhereToGo();

  }

}
