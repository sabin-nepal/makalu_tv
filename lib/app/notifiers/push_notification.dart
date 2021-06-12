
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/notification_helper.dart';
import 'package:makalu_tv/app/styles/colors.dart';

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
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    AwesomeNotifications().initialize(null, [
      NotificationChannel(
          channelKey: 'makalu_channel',
          channelName: 'Makalu notifications',
          channelDescription:
              'Notification channel for displaying news notification',
          defaultColor: AppColors.primaryColor,
          ledColor: Colors.white)
    ]);
  }

  getNotification(BuildContext context) async {
    FirebaseMessaging.onMessageOpenedApp.listen((message) async{
      await NotificationHelper().parseNotification(context, message.data);
    });
  }
}
