import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:vibes/Backend/Models/UserModel.dart';
import 'package:vibes/Home/home_screen.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:vibes/Profile/profile_screen.dart';
import 'package:vibes/Wishlist/wishlist_screen.dart';

late UserModel user;

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

List pages = [];

class _HomeMainState extends State<HomeMain> {
  int _selectedIndex = 0;
  static TextStyle optionStyle =
  TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600);


  @override
  Widget build(BuildContext context) {
    return getUser(context);
  }

  getUser(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data! == null) {
            return Placeholder();
          }
          else{
            final item = snapshot1.data!;
              user = UserModel(
                  uid: item['uid'],
                  name: item['name'],
                  imgurl: item['imgurl'],
                  email: item['email'],
                  phone: item['phone'],
                  nationality: item['nationality'],
                  birthdate: item['birthdate']
              );
              pages.clear();
              pages = [HomeScreen(User: user,), WishlistScreen(), ProfileScreen(),];
            return dataScreen(context);
          }
        } else {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  color: background
              ),
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Center(
                child: Container(
                  width: 100.sp,
                  height: 100.sp,
                  child: CircularProgressIndicator(
                    color: primary,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  dataScreen(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pages[_selectedIndex],
        extendBody: false,
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            child: GNav(
              rippleColor: primary,
              hoverColor: primary,
              gap: 8,
              activeColor: primary,
              iconSize: 24.sp,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: secondery,
              color: primary,
              tabs: [
                GButton(
                  borderRadius: BorderRadius.circular(8),
                  iconColor: Colors.grey,
                  textColor: primary,
                  icon: Icons.home,
                  iconSize: 30.sp,
                  text: 'Home',
                ),
                GButton(
                  borderRadius: BorderRadius.circular(8),
                  iconColor: Colors.grey,
                  textColor: primary,
                  icon: FontAwesomeIcons.solidHeart,
                  text: 'Wishlist',
                ),
                GButton(
                  borderRadius: BorderRadius.circular(8),
                  iconColor: primary,
                  textColor: primary,
                  icon: Icons.account_circle_sharp,
                  text: 'Profile',
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.imgurl)),
                  ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }


}
