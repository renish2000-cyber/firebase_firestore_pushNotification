import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    await messaging.requestPermission();
    await getToken();
    initLocalNotification();
    FirebaseMessaging.onMessage.listen((event) {
      showNotification(event);
    });

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
    );

  }

  /*
  * to just Initialize purpose
  * */
  void initLocalNotification() {
    var androidInitializationSetting =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializationSetting = DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSetting,
      iOS: iosInitializationSetting,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {

      },
    );
  }
}
