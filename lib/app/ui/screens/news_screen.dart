import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/colors.dart';

class NewsScreen extends StatelessWidget {
  final String title;
  final List news;
  NewsScreen({this.title, this.news});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
        centerTitle: true,
        title: Text(
          title,
        ),
      ),
      body: Container(),
    );
  }
}
