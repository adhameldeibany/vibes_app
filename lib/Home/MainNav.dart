// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:vibes/Backend/NavigationPack/VibesNavigationBar.dart';
// import 'package:vibes/Backend/NavigationPack/VibesNavigator.dart';
// import 'package:vibes/Backend/NavigationPack/Vibespages.dart' as Vpages;
// import 'package:vibes/Events/events_details.dart';
// import 'package:vibes/Events/events_screen.dart';
// import 'package:vibes/Home/HomeScreen.dart';
// import 'package:vibes/Methods/colors_methods.dart';
// import 'package:vibes/Sights/Story/story_audio.dart';
// import 'package:vibes/Sights/sights_details.dart';
//
// late Widget ActivePage;
//
// class MainPage extends StatefulWidget {
//   const MainPage({super.key});
//
//   @override
//   State<MainPage> createState() => _MainPageState();
// }
//
// bool a = false;
// bool b = true;
// List<Widget> pages = [StoryAudio(),EventScreen(),SightsDetails()];
// List<List<Widget>> subpages = [
//   [],
//   [],
//   []
// ];
//
// class _MainPageState extends State<MainPage> {
//
//
//   late int I;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Vpages.index = 0;
//     Vpages.pages = pages;
//     Vpages.subpages = subpages;
//     ActivePage = VibesNavigatorController().NavigateToPage();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Vibes_SafeNavHolder(
//         Context: context,
//         NavigationHeight: 72.sp,
//         OuterNavigationHeight: 21.72.sp,
//         Background: background,
//         NavigationBar: Vibes_NavigationBar(
//             NavigationHeight: 72.sp,
//             OuterNavigationHeight: 21.72.sp,
//             NavigationColor: Colors.white,
//             padding: EdgeInsets.symmetric(horizontal: 32.sp, vertical: 6.sp),
//             FabButton: InkWell(
//               onTap: (){
//                 setState(() {
//                   Vpages.index = 1;
//                   ActivePage = VibesNavigatorController().NavigateToPage();
//                   a = false;
//                   b = false;
//                 });
//               },
//               child: Vibes_IconFab(
//                   FabSize: 64.sp,
//                   icon: Icon(Icons.location_on_outlined,size: 27.sp,color: Colors.white,),
//                   BackgroundColor: primary,
//               ),
//             ),
//             ChildRight: InkWell(
//               onTap: (){
//                 setState(() {
//                   if (a == false) {
//                     Vpages.index = 2;
//                     ActivePage = VibesNavigatorController().NavigateToPage();
//                     b = false;
//                     a = true;
//                   }
//                 });
//               },
//               child: Vibes_ImageChild(
//                   width: 97.sp,
//                   height: 48.sp,
//                   imgsrc: AssetImage('assets/profile_img.png'),
//                   imgsize: 24.sp,
//                   label: 'Profile',
//                   ActiveColor: primary,
//                   NotActiveColor: nonselectedtext,
//                   activecontroller: a,
//                   labelfontfamily: 'Avenir',
//                   labelsize: 12.sp,
//                   spacebetween: 6.sp,
//               ),
//             ),
//             ChildLeft: InkWell(
//               onTap: (){
//                 setState(() {
//                   if (b == false) {
//                     Vpages.index = 0;
//                     ActivePage = VibesNavigatorController().NavigateToPage();
//                     a = false;
//                     b = true;
//                   }
//                 });
//               },
//               child: Vibes_IconChild(
//                   width: 97.sp,
//                   height: 48.sp,
//                   icon: Icons.home,
//                   iconsize: 24.sp,
//                   label: 'Home',
//                   ActiveColor: primary,
//                   NotActiveColor: nonselectedtext,
//                   activecontroller: b,
//                   labelfontfamily: 'Avenir',
//                   labelsize: 12.sp,
//                   spacebetween: 6.sp,
//               ),
//             ),
//         ),
//         activepage: ActivePage,
//     );
//   }
// }
