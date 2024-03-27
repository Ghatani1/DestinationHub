import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class Direction extends StatefulWidget {
  const Direction({super.key});

  @override
  State<Direction> createState() => _DirectionState();
}

class _DirectionState extends State<Direction> {
  void showNotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: 'basic_channel',
            title: 'Event List',
            body: 'Finally Its Working'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: const Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Camera Screen'),
            ]));
  }
}
