import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:vibes/Backend/Models/UserModel.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:vibes/Profile/EditData.dart';

bool edit = false;
bool phon = false;
String initialCountry = 'EG';
PhoneNumber Number = PhoneNumber(isoCode: 'EG');
final TextEditingController controller = TextEditingController();

FirebaseStorage storage = FirebaseStorage.instance;
String url = "";
var phonecontroller = TextEditingController();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  late UserModel cuser;

  @override
  Widget build(BuildContext context) {
    return getUser(context);
  }

  getUser(BuildContext context){
    final ref = FirebaseFirestore.instance.collection('users').where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
    return StreamBuilder(
      stream: ref,
      builder: (context, snapshot1) {
        if (snapshot1.hasData && snapshot1.data != null ) {
          if (snapshot1.data?.docs.length == 0) {
            return Placeholder();
          }
          else{
            final items = snapshot1.data!.docs;
              for(var item in items){
                  cuser = UserModel(
                      uid: item['uid'],
                      name: item['name'],
                      imgurl: item['imgurl'],
                      email: item['email'],
                      phone: item['phone'],
                      nationality: item['nationality'],
                      birthdate: item['birthdate']
                  );
                  Number = PhoneNumber(isoCode: cuser.phone[0],dialCode: cuser.phone[1],phoneNumber: cuser.phone[2]);
              }
            return edit? editScreen(context) : dataScreen(context);
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

  dataScreen(BuildContext context){
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        title: Text('Profile',
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: (){
              setState(() {
                edit = !edit;
              });
            },
            child: Text('Edit',
              style: TextStyle(color: primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.h, right: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(cuser.imgurl),radius: 64.sp,)
                    ],
                  ),
                  SizedBox(height: 8.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(cuser.name,
                        maxLines: 2,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h,),
                  Container(
                    width: 328.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                      child: Row(
                        children: [
                          Icon(Icons.email_outlined, color: Colors.grey, size: 24.sp,),
                          SizedBox(width: 10.w,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Email',
                                style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.w500),
                              ),
                              Text(cuser.email,
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Container(
                    width: 328.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                      child: Row(
                        children: [
                          Icon(Icons.phone_outlined, color: Colors.grey, size: 24.sp,),
                          SizedBox(width: 10.w,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Phone number',
                                style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.w500),
                              ),
                              Text(cuser.phone[2],
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Container(
                    width: 328.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                      child: Row(
                        children: [
                          Icon(Icons.flag_outlined, color: Colors.grey, size: 24.sp,),
                          SizedBox(width: 10.w,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Nationality',
                                style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.w500),
                              ),
                              Text(cuser.nationality,
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Container(
                    width: 328.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                      child: Row(
                        children: [
                          Icon(Icons.cake_outlined, color: Colors.grey, size: 24.sp,),
                          SizedBox(width: 10.w,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Date of birth',
                                style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.w500),
                              ),
                              Text(cuser.birthdate.toDate().toString().substring(0,10),
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  editScreen(BuildContext context){
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        title: Text('Profile',
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: (){
              setState(() {
                edit = !edit;
                phon = false;
              });
            },
            child: Text('Done',
              style: TextStyle(color: primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.h, right: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h,),
                  Stack(
                    children: [
                      CircleAvatar(backgroundImage: NetworkImage(cuser.imgurl),radius: 64.sp,),
                      InkWell(
                        onTap: () async {
                          await pickimage(ImageSource.gallery);
                        },
                        child: Container(
                          width: 40.sp,
                          height: 40.sp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                          ),
                          child: Icon(Icons.edit_outlined,color: primary,size: 30.sp,),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText(cuser.name,
                        maxLines: 2,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h,),
                  Container(
                    width: 328.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                      child: Row(
                        children: [
                          Icon(Icons.email_outlined, color: Colors.grey, size: 24.sp,),
                          SizedBox(width: 10.w,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Email',
                                style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.w500),
                              ),
                              Text(cuser.email,
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Container(
                    width: 328.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              phon?SizedBox():Icon(Icons.phone_outlined, color: Colors.grey, size: 24.sp,),
                              SizedBox(width:phon? 0: 10.sp,),
                              phon?
                              Container(
                                height: 55.h,
                                width: 270.w,
                                child: InternationalPhoneNumberInput(
                                  hintText: '',
                                  onInputChanged: (PhoneNumber number) {
                                    phonecontroller.text = number.toString();
                                    Number = number;
                                    print(number.phoneNumber);
                                  },
                                  onInputValidated: (bool value) {
                                    print(value);
                                  },
                                  spaceBetweenSelectorAndTextField: 0,
                                  selectorConfig: SelectorConfig(
                                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                    useBottomSheetSafeArea: true,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle: TextStyle(color: Colors.black),
                                  initialValue: Number,
                                  textFieldController: controller,
                                  formatInput: true,
                                  keyboardType:
                                  TextInputType.numberWithOptions(signed: true, decimal: true),
                                  inputDecoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primary,width: 2.w)),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,)),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,)),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,

                                  ),
                                  onSaved: (PhoneNumber number) {
                                    print('On Saved: $number');
                                  },
                                ),
                              )
                                    :
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Phone number',
                                    style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.w500),
                                  ),
                                  Text(cuser.phone[2],
                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () async {
                              if (phon) {
                                if (phonecontroller.text.length <=5) {
                                }else{
                                  await savephone();
                                }
                              }
                              setState(() {
                                phon = !phon;
                              });
                            },
                            child: phon? Icon(Icons.done_outline, color: CupertinoColors.activeGreen, size: 24.sp,) : Icon(Icons.edit_outlined, color: primary, size: 24.sp,)
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Container(
                    width: 328.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.flag_outlined, color: Colors.grey, size: 24.sp,),
                              SizedBox(width: 10.w,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Nationality',
                                    style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.w500),
                                  ),
                                  Text(cuser.nationality,
                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: (){
                              Get.to(EditData(type: "nationality"));
                            },
                            child: Icon(Icons.edit_outlined, color: primary, size: 24.sp,))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Container(
                    width: 328.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.cake_outlined, color: Colors.grey, size: 24.sp,),
                              SizedBox(width: 10.w,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Date of birth',
                                    style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.w500),
                                  ),
                                  Text(cuser.birthdate.toDate().toString().substring(0,10),
                                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                              onTap: (){
                                Get.to(EditData(type: "age"));
                              },
                              child: Icon(Icons.edit_outlined, color: primary, size: 24.sp,))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<String> uploadImageToStorage(Uint8List file) async{
    Reference ref = storage.ref().child("images/users/"+FirebaseAuth.instance.currentUser!.uid.toString());
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await  uploadTask;
    String downloadurl = await snapshot.ref.getDownloadURL();
    url = downloadurl;
    return downloadurl;
  }

  Future<String> saveData({required Uint8List file, bool ret = true}) async {
    String resp = "Some Error Occurred";
    String imageUrl = "";
    try{
      imageUrl = await uploadImageToStorage(file);
      final ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid.toString());
      await ref.update({
        "imgurl": imageUrl,
      });
      resp = 'success';
    }catch(err){
      resp = err.toString();
    }
    if (ret == true) {
      return imageUrl;
    }else{
      return resp;
    }
  }

  pickimage(ImageSource source) async{
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      Uint8List imgfile = await file.readAsBytes();
      saveData(file: imgfile);
      return imgfile;
    }
    print("No Images Selected");
  }
  
  savephone() async {
    final ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid.toString());
    await ref.update({
      'phone': [
        Number.isoCode.toString(),
        Number.dialCode.toString(),
        Number.phoneNumber.toString()
      ],
    });
  }

}
