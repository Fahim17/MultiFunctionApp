import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? st) {});
  }

  static void display(RemoteMessage message) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
      "multifuncapp",
      "multifuncapp channel",
      importance: Importance.max,
      priority: Priority.high,
    ));

    await _notificationsPlugin.show(
      id,
      message.notification!.title,
      message.notification!.body,
      notificationDetails,
      payload: message.data["route"],
    );
    try {} catch (e) {
      print("***ERROOR***$e");
    }
  }
}
