import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vibes/Auth/login_screen.dart';
import 'package:vibes/Methods/colors_methods.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {

  var emailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Get.off(LoginScreen());
        return false;
      },
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
            backgroundColor: background,
            leading: BackButton(
              color: Colors.black,
            )
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h,),
                  Text('Enter your email',
                    style: TextStyle(fontSize: 24.sp, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 80.h,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2.w)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h,),
                  InkWell(
                    onTap: () {
                      if (emailcontroller.text.length != 0) {
                        FirebaseAuth.instance.sendPasswordResetEmail(email: emailcontroller.text);
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.success,
                          text: "Reset Password Email Sent Successfully!",
                          onConfirmBtnTap: (){
                            Navigator.pop(context);
                          },
                          onCancelBtnTap: (){
                            Navigator.pop(context);
                          }
                        );
                      }else{
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            text: "Email Can't Be Empty!",
                        );
                      }
                    },
                    child: Container(
                      width: 328.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(child: Text('Continue', style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),)),
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
}
