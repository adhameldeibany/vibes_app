import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibes/Auth/login_screen.dart';
import 'package:vibes/Auth/signup2.dart';
import 'package:vibes/Methods/colors_methods.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 200.h, bottom: 50.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Vibes',
                      style: TextStyle(fontSize: 100.sp, fontFamily: 'Ogg', height: 0.8),
                    ),
                    Text('Every Stone has a Story',
                      style: TextStyle(fontSize: 20.sp, fontFamily: 'Ogg'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.off(Signup2());
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
                            'Create new account',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h,),
                    InkWell(
                      onTap: () {
                        Get.off(LoginScreen());
                      },
                      child: Container(
                        width: 328.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: primary, width: 2.w),
                          borderRadius: BorderRadius.circular(64),
                        ),
                        child: Center(
                          child: Text(
                            'Already have an account',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: primary
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
