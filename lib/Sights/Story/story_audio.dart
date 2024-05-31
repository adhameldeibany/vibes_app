import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibes/Backend/LyricPack/LyricModel.dart';
import 'package:vibes/Backend/LyricPack/LyricsPack.dart';
import 'package:vibes/Backend/Models/JourneyModel.dart';
import 'package:vibes/Methods/colors_methods.dart';


bool st =false;
Duration duration = Duration.zero;
Duration position = Duration.zero;
late List<JourneyModel> journeys;

class StoryAudio extends StatefulWidget {
  StoryAudio({required List<JourneyModel> Journeys}){
    journeys = Journeys;
  }

  @override
  State<StoryAudio> createState() => _StoryAudioState();
}

int inde = 0;

class _StoryAudioState extends State<StoryAudio> {
  bool k = true;
  bool x = true;
  bool f = true;
  late AudioPlayer player = AudioPlayer();
  List<LyricModel> lyrics = [];
  List<LyricModel> arlyrics = [];

  bool ar = false;
  double value = 0;

  AudioPlayer? audioPlayer;
  double sliderProgress = 111658;
  int playProgress = 0;
  double max_value = 211658;
  bool isTap = false;

  void initState() {
    super.initState();

    // Create the audio player.
    player = AudioPlayer();


    // Set the release mode to keep the source after playback has completed.
    player.setReleaseMode(ReleaseMode.stop);
    player.onPlayerStateChanged.listen((state) {
      setState(() {
        st = state == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    player.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });

    player.onPlayerComplete.listen((event) async {
      if (inde != journeys.length-1) {
        inde +=1;
        await player.setSource(UrlSource(ar?journeys[inde].ar:journeys[inde].en));
        position = Duration.zero;
        await player.resume();
        setState(() {
        });
      }
    });

    // Start the player as soon as the app is displayed.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(UrlSource(ar?journeys[inde].ar:journeys[inde].en));
      await player.resume();
    });
  }

  @override
  void dispose() {
    // Release all sources and dispose the player.
    player.dispose();

    super.dispose();
  }


  var playing = false;

  @override
  Widget build(BuildContext context) {
    return StreamMaker1(context);
  }

  Widget StreamMaker1(BuildContext context){

    final ref = FirebaseFirestore.instance.collection('sights').doc('hNxMf67qkvDUfvGRJrUa').collection('journey').doc(journeys[inde].did).collection('arlyrics').orderBy('id').snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return Placeholder();
          }
          else{
            arlyrics.clear();

            final items = snapshot1.data!.docs;
            for(var item in items){
              arlyrics.add(
                  LyricModel(
                      id: item['id'],
                      start: item['from'],
                      end: item['to'],
                      content: item['content']
                  )
              );

            }

            return StreamMaker2(context);
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

  Widget StreamMaker2(BuildContext context){

    final ref = FirebaseFirestore.instance.collection('sights').doc('hNxMf67qkvDUfvGRJrUa').collection('journey').doc(journeys[inde].did).collection('enlyrics').orderBy('id').snapshots();

    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return Placeholder();
          }
          else{
            lyrics.clear();

            final items = snapshot1.data!.docs;
            for(var item in items){
              lyrics.add(
                LyricModel(
                    id: item['id'],
                    start: item['from'],
                    end: item['to'],
                    content: item['content']
                )
              );

            }

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
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(journeys[inde].imgurl),
                fit: BoxFit.cover,
                colorFilter:
                ColorFilter.mode(Colors.black12, BlendMode.darken),
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff0A0A0A00), Color(0xff0A0A0A)],
                  begin: Alignment(0.0, -1.9),
                  end: Alignment(0, 1),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 10.w, right: 10.w, top: 30.h, bottom: 30.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BackButton(
                            color: Colors.white,
                            style: ButtonStyle(
                                iconSize: MaterialStateProperty.all(24.sp)),
                          ),
                          Text(
                            'Steps ${inde+1} / ${journeys.length}',
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.grey[350]),
                          ),
                          Icon(
                            Icons.share_outlined,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        journeys[inde].title,
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontFamily: 'Avenir',
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      x
                          ? Container(
                        width: 328.sp,
                        height: 328.sp,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                                image: NetworkImage(journeys[inde].imgurl),
                                fit: BoxFit.cover)),
                      )
                          : LyricsHolder(
                          Height: 328.sp,
                          Width: 328.sp,
                          BackgroundColor: Colors.black26,
                          Opacity: 0.7,
                          BorderRaduis: 16,
                          Child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LyricsContainer(
                                Textalign: ar?TextAlign.end:TextAlign.start,
                                Lyrics: ar?arlyrics:lyrics,
                                ActiveTextColor: Colors.white,
                                NotActiveTextColor: Color(0xffACACAC).withOpacity(0.5),
                                PlayerSeekTimer: position.toString().substring(2).substring(0,9),
                                FontFamily: "Avenir",
                                TextWeight: FontWeight.w600,
                                TextSize: 24.sp),
                          )
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.w, right: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  x = !x;
                                });
                              },
                              child: Row(
                                children: [
                                  x
                                      ? Icon(
                                    Icons.image_outlined,
                                    size: 24.sp,
                                    color: Colors.white,
                                  )
                                      : Icon(
                                    Icons.text_snippet_outlined,
                                    size: 24.sp,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  if (k == true ){
                                    k = !k;
                                    player.setPlaybackRate(1.5);
                                  } else if (f == false && k == false){
                                    k = !k;
                                    f = !f;
                                    player.setPlaybackRate(1);
                                  } else{
                                    f = !f;
                                    player.setPlaybackRate(2);
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  k ? Text(
                                    '1X',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp),
                                  )
                                      : f ? Text(
                                    '1.5X',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp),
                                  )
                                      : Text(
                                    '2X',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                                onTap: () async {
                                  ar = !ar;
                                  await player.pause();
                                  position = Duration.zero;
                                  player.seek(position);
                                  await player.setSource(UrlSource(ar?journeys[inde].ar:journeys[inde].en));
                                  await player.resume();
                                  setState(() {
                                  });
                                },
                                child: Icon(
                                  Icons.translate,
                                  size: 24.sp,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 340.w,
                            child: Slider.adaptive(
                              onChangeEnd: (new_value) {
                                setState(() {
                                  position = Duration(milliseconds: new_value.toInt());
                                  player.seek(position);
                                });
                              },
                              min: 0.0,
                              value: position.inMilliseconds.toDouble(),
                              max: duration.inMilliseconds.toDouble(),
                              onChanged: (value) {},
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              position.toString().split('.')[0].substring(2),
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              duration.toString().split('.')[0].substring(2),
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Duration currentPosition = position;
                              Duration targetPosition = currentPosition - const Duration(seconds: 10);
                              player.seek(targetPosition);
                            },
                            child: Center(
                              child: Icon(
                                Icons.replay_10,
                                size: 24.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          InkWell(
                            onTap: () async {
                              await player.pause();
                              if (inde != 0) {
                                inde-=1;
                              }else{
                                inde=journeys.length-1;
                              }
                              position = Duration.zero;
                              player.seek(position);
                              await player.setSource(UrlSource(ar?journeys[inde].ar:journeys[inde].en));
                              await player.resume();
                              setState(() {
                              });
                            },
                            child: Center(
                              child: Icon(
                                Icons.skip_previous,
                                size: 24.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60.0),
                              border: Border.all(color: Colors.white),
                              color: Colors.black26.withOpacity(0.5),
                            ),
                            width: 60.0,
                            height: 60.0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (st) {
                                    player.pause();
                                    st = false;
                                  }else{
                                    player.resume();
                                    st = true;
                                  }
                                });
                              },
                              child: Center(
                                child: Icon(
                                  st?Icons.pause:Icons.play_arrow,
                                  size: 24.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await player.pause();
                              if (inde != journeys.length-1) {
                                inde+=1;
                              }else{
                                inde=0;
                              }
                              position = Duration.zero;
                              player.seek(position);
                              await player.setSource(UrlSource(ar?journeys[inde].ar:journeys[inde].en));
                              await player.resume();
                              setState(() {
                              });
                            },
                            child: Center(
                              child: Icon(
                                Icons.skip_next,
                                size: 24.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          InkWell(
                            onTap: () {
                              Duration currentPosition = position;
                              Duration targetPosition = currentPosition + const Duration(seconds: 10);
                              player.seek(targetPosition);
                            },
                            child: Center(
                              child: Icon(
                                Icons.forward_10,
                                size: 24.sp,
                                color: Colors.white,
                              ),
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
        ],
      ),
    );
  }

}
