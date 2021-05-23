import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/theme.dart';
import 'package:makalu_tv/app/ui/general/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makalu Tv',
      theme: theme,
      home: HomePage(),
    );
  }
}