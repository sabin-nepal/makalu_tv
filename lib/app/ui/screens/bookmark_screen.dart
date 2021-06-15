import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/styles/styles.dart';

class BookMakrkScreen extends StatefulWidget {
  @override
  _BookMakrkScreenState createState() => _BookMakrkScreenState();
}

class _BookMakrkScreenState extends State<BookMakrkScreen> {
  UserSharePreferences _userSharePreferences = UserSharePreferences();
  List news = [];
  @override
  void initState() {
    super.initState();
    _fetchBookmark();
  }

  _fetchBookmark() async {
    var data = await _userSharePreferences.getBookMark();
    for (var i in data) {
      news.add(json.decode(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
        centerTitle: true,
        title: Text(
          'BookMark',
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(AppSizes.padding),
        child: ListView.builder(
          itemCount: news.length,
          itemBuilder: (context,i){
            var _news = news[i];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(imageUrl: _news['media'].first['path']),
                  Text(_news['title'],style: boldText,),
                ],
              ),
            );
          }),
      ),
    );
  }
}
