import 'dart:convert';
import 'dart:math';

import 'package:crudoperation/common.dart';
import 'package:crudoperation/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    /*
    * Move Request permission one fist screen (eg:splash screen)
    * */
    await messaging.requestPermission();
    await getToken();
    initLocalNotification();

    /*
    * When App open in Foreground (Screen display) at that time this lister call
    * */
    FirebaseMessaging.onMessage.listen((event) {
      showNotification(event);
    });

    /*
    * When APP is work in background(Minimize)
    * Ans user click on Notification At that time this listener call
    * */
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      String? title=event.notification?.title;
      String? body=event.notification?.body;
      Navigator.push(Mcommon.navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => NotificationScreen(title: title!,body: body!,),));
    });

    /*
     * When user killed App and then click on notification at that time get data from this method
     * addPostFrameCallback function required due to current state is getting null so first widget tree build then redirect to screen
     * */
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      String? title=initialMessage.notification?.title;
      String? body=initialMessage.notification?.body;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.push(Mcommon.navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => NotificationScreen(title: title!,body: body!,),));
      });
    }

  }
  /*
  * getToken method return device specific token to send Specific user Notification
  *
  * */
  Future<String?> getToken() async {
    print("Token:${await messaging.getToken()}");
    return await messaging.getToken();
  }

  Future<void> showNotification(RemoteMessage message)async{

    /*
    * Create json of data and pass to payload function
    * */
    Map<String,dynamic> data={
      "title":message.notification?.title,
      "body":message.notification?.body,
    };

    AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      "High Importance Notification",
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      androidNotificationChannel.id,
      androidNotificationChannel.name,
      importance: Importance.high,
      ticker: 'ticker',
    );

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);

    int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    flutterLocalNotificationsPlugin.show(
      notificationId,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: jsonEncode(data),
    );

  }

  /*
  * to just Initialize purpose
  * */
  void initLocalNotification() {
    var androidInitializationSetting = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializationSetting = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSetting,
      iOS: iosInitializationSetting,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        /*
        * When user click on local Notification to change screen which take payload
        * */
        Map<String,dynamic> data=jsonDecode(payload.payload!);
        Navigator.push(Mcommon.navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => NotificationScreen(title: data["title"],body: data["body"],),));
      },
    );
  }
}
