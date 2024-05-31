import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vibes/Auth/auth_screen.dart';
import 'package:vibes/Auth/forget_screen.dart';
import 'package:vibes/Auth/signup2.dart';
import 'package:vibes/Backend/GlobalMethods.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:vibes/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  bool passToggle = true;

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
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 60.h,),
                  Text('Vibes',
                    style: TextStyle(fontSize: 60.sp, fontFamily: 'Ogg', height: 0.5),
                  ),
                  SizedBox(height: 35.h,),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Sign in with',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              await signInWithGoogle(context);
                            },
                            child: Container(
                                width: 95.w,
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
                                        image: AssetImage('assets/google.png')
                                    ),
                                  ],
                                )
                            ),
                          ),
                          SizedBox(width: 16.w,),
                          InkWell(
                            onTap: () async {
                              await signInWithApple();
                            },
                            child: Container(
                                width: 95.w,
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
                                          image: AssetImage('assets/apple.png')
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          SizedBox(width: 16.w,),
                          InkWell(
                            onTap: () async {
                              await SignInWithTwitter();
                            },
                            child: Container(
                                width: 95.w,
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
                                          image: AssetImage('assets/X.png')
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h,),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Password", style: TextStyle(fontSize: 14.sp)),
                        ],
                      ),
                      SizedBox(height: 10.h,),
                      SizedBox(
                        height: 50.h,
                        width: 328.w,
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.black),
                          controller: passwordcontroller,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: passToggle,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,)),
                              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,)),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primary,width: 2.w)),
                              suffix: InkWell(
                                onTap: (){
                                  setState(() {
                                    passToggle = !passToggle;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(passToggle ? Icons.visibility_off : Icons.visibility, color: Colors.grey,),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h,),
                      InkWell(
                        onTap: ()  {
                          if (emailcontroller.text.length == 0 || passwordcontroller.text.length == 0) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: "Please Complete Data",
                            );
                          }else{
                            signInWithEmail(emailcontroller.text,passwordcontroller.text,context);
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
                      SizedBox(height: 15.h,),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.off(ForgotScreen());
                            },
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(color: primary, fontSize: 14.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h,),
                  InkWell(
                    onTap: () {
                      Get.off(Signup2());
                    },
                    child: Container(
                        width: 328.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: primary)
                        ),
                        child: Center(
                          child: Text("Create new account",
                            style: TextStyle(color: primary, fontSize: 16.sp,fontWeight: FontWeight.w500),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 20.h,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  signInWithEmail(String email, String password, BuildContext context)async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      await prefs.setBool('onboarding', true);
      GlobalMethods().CheckWhereToGo();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "No User Found For That Email",
        );
      }
      else if (e.code == 'wrong-password') {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Wrong Password Provided For That User.",
        );
      }
    }
  }
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
