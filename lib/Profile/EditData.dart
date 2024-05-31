import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country/country.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scroll_wheel_date_picker/scroll_wheel_date_picker.dart';
import 'package:vibes/Methods/colors_methods.dart';

TextEditingController searchcontroller2 = new TextEditingController();
int selectedValue2 = 0;
bool a = true;
bool b = false;
String Selected = "";
String SelectedSearch = "";
late Timestamp birth ;
late String Typ;

class EditData extends StatefulWidget {
  EditData({required String type}){
    Typ = type;
  }

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  @override
  Widget build(BuildContext context) {
    return Typ=="nationality"?EditNationality(context):EditAge(context);
  }

  EditNationality(BuildContext context){
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Choose your nationality',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h,),
              SizedBox(
                height: 50.h,
                width: 328.w,
                child: TextFormField(
                  textAlign: TextAlign.start,
                  controller: searchcontroller2,
                  onChanged: (value) {
                    this.setState(() {
                      SelectedSearch = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for your nationality',
                    hintStyle: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
                    contentPadding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,)),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primary,width: 2.w)),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h,),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Countries.values.length,
                  itemBuilder: (context, index) {
                    final country = Countries.values[index];
                    return country.nationality!=""?
                    country.nationality.toLowerCase().contains(SelectedSearch.toLowerCase())? Column(
                      children: [
                        InkWell(
                          onTap: (){
                            // setState(() {
                            //   selectedValue2 = 1 as int;
                            // });
                            this.setState(() {
                              Selected = country.nationality;
                            });
                          },
                          child: Container(
                            width: 328.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                                color: Selected==country.nationality ? secondery : Colors.white,
                                borderRadius: BorderRadius.circular(64),
                                border: Border.all(color: Selected==country.nationality ? primary : Colors.white, width: 1.5.w)
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.w, right: 16.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 24.sp,
                                        height: 24.sp,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                        ),
                                        child: Text(country.flagEmoji,
                                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(width: 8.w,),
                                      Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 200.w
                                        ),
                                        child: AutoSizeText(country.nationality,
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Transform.scale(
                                    scale: 1,
                                    child: Radio(
                                      activeColor: primary,
                                      value: country.nationality,
                                      groupValue: Selected,
                                      onChanged: (value) {
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h,),
                      ],
                    )
                        :SizedBox()
                        :SizedBox();
                  },
                ),
              ),
              SizedBox(height: 24.h,),
              InkWell(
                onTap: () async {
                  if (Selected == "") {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.error,
                      text: "Choose Your Nationality",
                    );
                  }else{
                    final ref = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid.toString());
                    await ref.update({'nationality': Selected});
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: 328.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(child: Text('Done', style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),)),
                ),
              ),
              SizedBox(height: 10.h,),
            ],
          ),
        ),
      ),
    );
  }

  EditAge(BuildContext context){
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Enter your birthday',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h,),
              SizedBox(
                width: 328.w,
                height: 200.h,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Container(
                      color: background,
                      child: ScrollWheelDatePicker(
                        initialDate: DateTime.now(),
                        lastDate: DateTime.now(),
                        startDate: DateTime.utc(DateTime.now().year-100),
                        onSelectedItemChanged: (value) {
                          birth = Timestamp.fromDate(value);
                        },
                        theme: FlatDatePickerTheme(
                          wheelPickerHeight: 200.h,
                          overlay: ScrollWheelDatePickerOverlay.holo,
                          itemTextStyle: defaultItemTextStyle.copyWith(color: Colors.black),
                          overlayColor: Colors.black,
                          overAndUnderCenterOpacity: 0.2,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    )
                ),
              ),
              SizedBox(height: 24.h,),
              InkWell(
                onTap: () async {
                  final ref = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid.toString());
                  await ref.update({'birthdate': birth});
                  Navigator.pop(context);
                },
                child: Container(
                  width: 328.w,
                  height: 48.h,
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(child: Text('Done',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
