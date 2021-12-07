import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:multifuncapp/services/local_notification_service.dart';

class NotificationAPI extends StatefulWidget {
  NotificationAPI({
    Key? key,
  }) : super(key: key);

  @override
  _NotificationAPIState createState() => _NotificationAPIState();
}

class _NotificationAPIState extends State<NotificationAPI> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("********Notification API Initializing********");

    LocalNotificationService.initialize(context);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("the app is in the terminated state");
      if (message != null) {
        final routeFromMessage = message.data["NotiData"];

        print(routeFromMessage);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      print("forground work");
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }

      //LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(
          "When the app is in background but opened and user taps on the notification");
      final notidataFromMessage = message.data["NotiData"];

      print(notidataFromMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Center(
        child: Text(
      "Notification Feature: ON",
      style: TextStyle(fontSize: 12),
    ));
  }
}
