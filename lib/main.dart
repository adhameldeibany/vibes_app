import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibes/Methods/colors_methods.dart';
import 'package:vibes/Splash/splash.dart';
import 'package:vibes/firebase_options.dart';

displaynotifications(){
  AwesomeNotifications().initialize(
      'resource://drawable/ic_stat_frame_1',
      [
        NotificationChannel(
            channelGroupKey: 'vibes_channel_group',
            channelKey: 'vibes_channel',
            channelName: 'Vibes notifications',
            channelDescription: 'Notification channel for Vibes Events',
            defaultColor: primary,
            playSound: true,
            channelShowBadge: true,
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'vibes_channel_group',
            channelGroupName: 'Vibes group')
      ],
      debug: true
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  displaynotifications();
  AwesomeNotifications().requestPermissionToSendNotifications();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 0,
          channelKey: "vibes_channel",
          title: message.notification!.title,
          body: message.notification!.body,
          bigPicture: "resource://mipmap/ic_launcher",
          notificationLayout: NotificationLayout.BigPicture,
          wakeUpScreen: true,
        ),
      );
  });
}
late SharedPreferences prefs ;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  prefs = await SharedPreferences.getInstance();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
      DevicePreview(
          enabled: false,
          builder: (context) => MyApp()
      ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

int i =0;

class _MyAppState extends State<MyApp> {
  getToken()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    String? myToken = await FirebaseMessaging.instance.getToken();
    print("=====================================================>$myToken");
  }

  @override
  void initState() {
    getToken();
    displaynotifications();
    AwesomeNotifications().requestPermissionToSendNotifications();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("======================");
        print(message.notification!.title);
        print(message.notification!.body);
        print("======================");

        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: i,
                channelKey: "vibes_channel",
                title: message.notification!.title,
                body: message.notification!.body,
                bigPicture: "resource://mipmap/ic_launcher",
                notificationLayout: NotificationLayout.BigPicture,
                wakeUpScreen: true,
            ),
        );

        i++;

      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]
    );

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xffF5F5F5) ,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.dark, // For iOS (dark icons)
    ));

    return ScreenUtilInit(
        designSize: Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
      builder: (_ , child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        );
      },
    );
  }
}
