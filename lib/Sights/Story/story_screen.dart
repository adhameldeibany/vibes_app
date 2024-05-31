import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timelines/timelines.dart';
import 'package:vibes/Backend/Models/JourneyModel.dart';
import 'package:vibes/Backend/Models/SightModel.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:vibes/Sights/Story/story_audio.dart';

List<JourneyModel> journeys = [];

late SightModel sight;

class StoryScreen extends StatefulWidget {
  StoryScreen({required SightModel Sight}){
    sight = Sight;
  }

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamMaker(context);
  }

  Widget StreamMaker(BuildContext context){

    final ref = FirebaseFirestore.instance.collection('sights').doc(sight.id).collection('journey').orderBy('id').snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return Placeholder();
          }
          else{
            journeys.clear();

            final items = snapshot1.data!.docs;
            for(var item in items){
              journeys.add(
                JourneyModel(
                    title: item['title'],
                    ar: item['ar'],
                    en: item['en'],
                    length: item['length'],
                    id: item['id'],
                    imgurl: item['imgurl'],
                    did: item['did']
                )
              );

            }

            final now = DateTime.now();

            return DataScreen(context);
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

  Widget DataScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 720.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(sight.img1),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
              ),
            ),
            child: Container(
              height: 720.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff0A0A0A00), Color(0xff0A0A0A)],
                  begin: Alignment(0.0, -1.9),
                  end: Alignment(0, 1),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 30.h, bottom: 30.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(
                          color: Colors.white,
                          style: ButtonStyle(iconSize: MaterialStateProperty.all(24.sp)),
                        ),
                        Icon(Icons.share_outlined, color: Colors.white, size: 24.sp,),
                      ],
                    ),
                    SizedBox(height: 10.h,),
                    Text(sight.name,
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Avenir'),
                    ),
                    SizedBox(height: 30.h,),
                    Text('The journey steps',
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Avenir'),
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return FixedTimeline.tileBuilder(
                              theme: TimelineThemeData(color: Colors.white),
                              builder: TimelineTileBuilder.connectedFromStyle(
                                contentsAlign: ContentsAlign.alternating,
                                oppositeContentsBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text("Step "+journeys[index].id,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey[400], fontSize: 12.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                                      ),
                                      Text(journeys[index].title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                                      ),
                                      Text(journeys[index].length,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey[400], fontSize: 12.sp, fontWeight: FontWeight.w600, fontFamily: 'Avenir'),
                                      ),
                                    ],
                                  ),
                                ),
                                connectorStyleBuilder: (context, index) => ConnectorStyle.solidLine,
                                firstConnectorStyle: ConnectorStyle.transparent,
                                indicatorStyleBuilder: (context, index) => IndicatorStyle.dot,
                                itemCount: journeys.length,
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 80.h,
        color: Color(0xff0C0C0A),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Get.to(StoryAudio(Journeys: journeys,));
              },
              child: Container(
                width: 328.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(64),
                ),
                child: Center(
                  child: Text(
                    'Start the journey',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Avenir'
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
