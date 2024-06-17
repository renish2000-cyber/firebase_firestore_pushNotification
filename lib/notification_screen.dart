import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
class NotificationScreen extends StatefulWidget {
  String title;
  String body;

  NotificationScreen({required this.title,required this.body,super.key});


  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("Notification Screen"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.title.toString()),
            Text(widget.body.toString()),
          ],
        ),
      ),
    );
  }
}
