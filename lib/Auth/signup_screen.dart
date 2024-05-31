import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:vibes/Auth/signup2.dart';
import 'package:vibes/Backend/GlobalMethods.dart';
import 'package:vibes/Backend/Models/UserModel.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:vibes/Onboarding/Data%20collection/nationality_screen.dart';


late UserModel user;

var firstnamecontroller = TextEditingController();
var lastnamecontroller = TextEditingController();
var emailcontroller = TextEditingController();
var phonecontroller = TextEditingController();
var passwordcontroller = TextEditingController();
var confirmpasswordcontroller = TextEditingController();

class SignupScreen extends StatefulWidget {
  SignupScreen({required UserModel User}){
    user = User;
    try{
      firstnamecontroller.text = user.name.split(' ')[0];
    }catch(e){

    }try{
      lastnamecontroller.text = user.name.split(' ')[1];
    }catch(e){

    }try{
      emailcontroller.text = user.email;
    }catch(e){

    }
    passwordcontroller.clear();
    confirmpasswordcontroller.clear();
  }

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool passToggle = true;

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'EG';
  PhoneNumber Number = PhoneNumber(isoCode: 'EG');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Get.off(Signup2());
        return false;
      },
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          leading: user.uid!=""? SizedBox() : BackButton(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Complete your account',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("First name", style: TextStyle(fontSize: 14.sp)),
                            ],
                          ),
                          SizedBox(height: 5.h,),
                          SizedBox(
                            width: 152.w,
                            height: 50.h,
                            child: TextFormField(
                              enabled: firstnamecontroller.text.length==0? true : false,
                              controller: firstnamecontroller,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,)),
                                border: OutlineInputBorder(borderSide: BorderSide(color: primary,)),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primary,width: 2.w)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 24.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Last name", style: TextStyle(fontSize: 14.sp)),
                            ],
                          ),
                          SizedBox(height: 5.h,),
                          SizedBox(
                            width: 152.w,
                            height: 50.h,
                            child: TextFormField(
                              enabled: lastnamecontroller.text.length==0? true : false,
                              controller: lastnamecontroller,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,)),
                                border: OutlineInputBorder(borderSide: BorderSide(color: primary,)),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primary,width: 2.w)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email", style: TextStyle(fontSize: 14.sp)),
                    ],
                  ),
                  SizedBox(height: 5.h,),
                  SizedBox(
                    height: 50.h,
                    width: 328.w,
                    child: TextFormField(
                      enabled: emailcontroller.text.length==0? true : false,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black),
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,)),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primary,width: 2.w)),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h,),
                  Container(
                    height: 55.h,
                    child: InternationalPhoneNumberInput(
                      hintText: '',
                      onInputChanged: (PhoneNumber number) {
                        Number = number;
                        phonecontroller.text = number.toString();
                        print(number.phoneNumber);
                      },
                      onInputValidated: (bool value) {
                        print(value);
                      },
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
                  ),
                  SizedBox(height: 32.h,),
                  user.uid==""?Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Password", style: TextStyle(fontSize: 14.sp)),
                    ],
                  ):SizedBox(height: 14.sp,),
                  SizedBox(height: 10.h,),
                  user.uid==""?
                  SizedBox(
                    height: 50.h,
                    width: 328.w,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black),
                      controller: passwordcontroller,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: passToggle,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 10.h, left: 10.w, right: 10.w),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey,)),
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,)),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primary,width: 2.w)),
                          suffix: InkWell(
                            onTap: (){
                              setState(() {
                                passToggle = !passToggle;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(passToggle ? Icons.visibility_off : Icons.visibility, color: Colors.grey,),
                              ],
                            ),
                          )
                      ),
                    ),
                  )
                      :
                  SizedBox(
                    height: 50.h,
                    width: 328.w,
                  ),
                  SizedBox(height: 48.h,),
                  InkWell(
                    onTap: () async {
                      if(user.uid==""){
                        if (firstnamecontroller.text.length == 0 ||
                            lastnamecontroller.text.length == 0 ||
                            passwordcontroller.text.length == 0 ||
                            emailcontroller.text.length == 0 ||
                            phonecontroller.text.length == 0) {
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: "Please Complete Data",
                            );
                        }else{
                          await SignupWithEmailAndPassword(context);
                        }
                      }else{
                        final ref = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid.toString());
                        Map<String, dynamic> use = {
                          'uid': user.uid,
                          'name': user.name,
                          'imgurl': user.imgurl,
                          'email': user.email,
                          'phone': [
                            Number.isoCode.toString(),
                            Number.dialCode.toString(),
                            Number.phoneNumber.toString()
                          ],
                          'nationality': user.nationality,
                          'birthdate': user.birthdate
                        };
                        await ref.set(use);
                        GlobalMethods().CheckWhereToGo();
                      }
                    },
                    child: Container(
                      width: 328.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Continue",
                            style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SignupWithEmailAndPassword(BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailcontroller.text.toString(),
        password: passwordcontroller.text.toString(),
      );
      final ref = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid.toString());
      Map<String, dynamic> use = {
        'uid': FirebaseAuth.instance.currentUser!.uid.toString(),
        'name': firstnamecontroller.text.toString() + " " + lastnamecontroller.text.toString(),
        'imgurl': 'https://firebasestorage.googleapis.com/v0/b/flocker-vibes.appspot.com/o/users%2Fuser2.jpg?alt=media&token=2dec32b9-e490-49a4-974d-51fc5caa73e5',
        'email': emailcontroller.text.toString(),
        'phone': phonecontroller.text.toString(),
        'nationality': '',
        'birthdate': Timestamp.fromDate(DateTime.utc(1820, DateTime.november, 19))
      };
      await ref.set(use);
      GlobalMethods().CheckWhereToGo();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "The password provided is too weak.",
        );
      }
      else if (e.code == 'email-already-in-use') {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "The account already exists for that email.",
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
