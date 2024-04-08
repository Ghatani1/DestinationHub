import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:destination/controllers/nav_bar_controller.dart';
import 'package:destination/controllers/notification_controller.dart';
import 'package:destination/firebase_options.dart';
import 'package:destination/utils/colors.dart';
import 'package:destination/services/log_reg_authentication.dart';
import 'package:destination/shared_preferences/SharedPref.dart';
import 'package:destination/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPref().getUserData();
  User? user = await Authentication().autoLogin();

  Get.put(NotificationController());
  AwesomeNotifications().initialize(
    'resource://drawable/ic_launcher',
    [
      NotificationChannel(
        channelKey: 'added_event',
        channelName: 'Added Event Notification',
        channelDescription: 'Added Notification',
        playSound: true,
        enableVibration: true,
        defaultColor: kSecondary,
      ),
      NotificationChannel(
        channelKey: 'event_reminder',
        channelName: 'Event Reminder notifications',
        channelDescription: 'Even Notification channel For basic tests',
        playSound: true,
        enableVibration: true,
        defaultColor: kSecondary,
      ),
      NotificationChannel(
          channelKey: 'own_reminder',
          channelName: 'Personal Reminder',
          channelDescription: 'Remind About Your Event',
          playSound: true,
          enableVibration: true,
          defaultColor: kPrimary,
          ledColor: kWhite)
    ],
  );
  Get.put(NavBarController());
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'destination',
    initialRoute:
        // '/EditPlace',
        user != null ? '/HomePage' : '/IntroPages',
    getPages: routes,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white, // Set background color here
    ),
  ));
}
