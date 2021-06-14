import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/notification_helper.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

class PushNotificationsService {
  PushNotificationsService._();

  factory PushNotificationsService() => _instance;

  static final PushNotificationsService _instance =
      PushNotificationsService._();

  Future<void> init() async {
    // For iOS request permission first.
    var isNotification = await UserSharePreferences().isNotification();
    if (isNotification)
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
  }

  getNotification(BuildContext context) async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await NotificationHelper().parseNotification(context, message.data);
    });
  }
}
