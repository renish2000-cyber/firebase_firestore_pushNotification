import 'package:crudoperation/common.dart';
import 'package:crudoperation/notification_service/notificationService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'login.dart';
import 'notification_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /*
  * To get Notification on when app is killed
  *  or When App is Minimized or in background at that time this listener call
  * */
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationService().initNotification();
  runApp(const MyApp());
}

/*
* To run notification in background (When App is kill) create this function and this function must be top level function
* When App is Killed Notification not received IS support till android 11
* Above Android 12 we need permission ?? some device wor it take time after  work
* */
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey:Mcommon.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}