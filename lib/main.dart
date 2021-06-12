import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/notifiers/push_notification.dart';
import 'package:makalu_tv/makalu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PushNotificationsService().init();
  runApp(MyApp());
}
