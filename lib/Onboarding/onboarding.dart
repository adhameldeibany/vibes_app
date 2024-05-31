import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibes/Backend/Components/OnBoardingPage.dart';
import 'package:vibes/Backend/GlobalMethods.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:vibes/main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

int currentPage = 0;
PageController controller = PageController();

class _OnboardingScreenState extends State<OnboardingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 60.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: currentPage >= 0 ? primary : Color(0xffACACAC),
                      borderRadius: BorderRadius.circular(64),
                    ),
                  ),
                  Container(
                    width: 60.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: currentPage >= 1 ? primary : Color(0xffACACAC),
                      borderRadius: BorderRadius.circular(64),
                    ),
                  ),
                  Container(
                    width: 60.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: currentPage >= 2 ? primary : Color(0xffACACAC),
                      borderRadius: BorderRadius.circular(64),
                    ),
                  ),
                  Container(
                    width: 60.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: currentPage >= 3 ? primary : Color(0xffACACAC),
                      borderRadius: BorderRadius.circular(64),
                    ),
                  ),
                  Container(
                    width: 60.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: currentPage >= 4 ? primary : Color(0xffACACAC),
                      borderRadius: BorderRadius.circular(64),
                    ),
                  ),
                ],
              ),
            ),
            PageView(
              controller: controller,
              onPageChanged: (index){
                setState(() {
                  currentPage = index;
                });
              },
              children: [
                onBoardingPage(
                    assetimage: 'assets/1.png',
                    title: 'EXPLORE \nSIGHTS',
                    subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                ),
                onBoardingPage(
                    assetimage: 'assets/2.png',
                    title: 'CREATE \nPLANS',
                    subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                ),
                onBoardingPage(
                    assetimage: 'assets/3.png',
                    title: 'DISCOVER \nEVENTS',
                    subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                ),
                onBoardingPage(
                    assetimage: 'assets/4.png',
                    title: 'EXPLORE \nACTIVITIES',
                    subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                ),
                onBoardingPage(
                    assetimage: 'assets/5.png',
                    title: 'EXPLORE \nTrips',
                    subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 76.h),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        controller.jumpToPage(4);
                      });
                    },
                    child: Text('Skip',
                      style: TextStyle(fontSize: 16.sp, ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    currentPage == 0 ? SizedBox(width: 0, height: 0,): InkWell(
                      onTap: () {
                        setState(() {
                          controller.jumpToPage(currentPage-1);
                        });
                      },
                      child: Container(
                        width: 48.sp,
                        height: 48.sp,
                        decoration: BoxDecoration(
                          border: Border.all(color: primary),
                          shape: BoxShape.circle
                        ),
                        child: Center(
                          child: Icon(Icons.arrow_back, color: primary, size: 24.sp,),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w,),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (currentPage == 4) {
                            prefs.setBool("onboarding", true);
                            GlobalMethods().CheckWhereToGo();
                          }else{
                            controller.jumpToPage(currentPage+1);
                          }
                        });
                      },
                      child: Container(
                        width: 264.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(currentPage == 4 ? 'Start' : 'Next',
                            style: TextStyle(color: Colors.white, fontSize: 16.sp,fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}