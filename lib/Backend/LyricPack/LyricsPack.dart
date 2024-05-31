import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vibes/Backend/LyricPack/LyricModel.dart';

Widget LyricsHolder({
  required double Height,
  required double Width,
  required Color BackgroundColor,
  double Opacity = 1,
  double BorderRaduis = 0,
  Widget? Child
}){
 return Container(
   height: Height,
   width: Width,
   decoration: BoxDecoration(
     color: BackgroundColor.withOpacity(Opacity),
     borderRadius: BorderRadius.circular(BorderRaduis)
   ),
   child: Child == null?SizedBox(width: 0,height: 0,):Child,
 );
}

Widget LyricsContainer({
  required List<LyricModel> Lyrics,
  String? FontFamily,
  FontWeight? TextWeight,
  required Color ActiveTextColor,
  required Color NotActiveTextColor,
  required String PlayerSeekTimer,
  required double TextSize,
  required TextAlign Textalign
}){
  FocusNode myFocusNode = FocusNode();
  return SingleChildScrollView(
    child: Container(
      constraints: new BoxConstraints(
        minWidth: double.infinity,
      ),
      child: Text.rich(TextSpan(
          children: Lyrics
              .map((e) {
              DateFormat format = new DateFormat("mm:ss.SSS");
              DateTime dateTimestart = format.parse(e.start.substring(3).replaceAll(',', '.'));
              DateTime dateTimeend = format.parse(e.end.substring(3).replaceAll(',', '.'));
              DateTime dateTimeseek = format.parse(PlayerSeekTimer);
                return TextSpan(
                text: e.content,
                style: TextStyle(
                  fontFamily: FontFamily == null?"MohamedHesham":FontFamily,
                  color: (dateTimeseek.isAfter(dateTimestart) && dateTimeseek.isBefore(dateTimeend))? ActiveTextColor: NotActiveTextColor,
                  fontSize: TextSize,
                  fontWeight: TextWeight == null?FontWeight.w100:TextWeight,
                ),
                recognizer:TapGestureRecognizer()
                  ..onTap = () {
                    print('datastart ${dateTimestart} + dataseek ${dateTimeseek} + dataend ${dateTimeend}');
                  });
              })
              .toList()
      ),textAlign: Textalign,
      ),
    ),
  );
}