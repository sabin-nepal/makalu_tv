import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
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
    setState(() {});
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
        child: news.length < 1
            ? Center(
                child: Text(
                "No news added as bookmark",
                style: titleText,
              ))
            : ListView.separated(
                separatorBuilder: (context, i) => SizedBox(height: 15),
                itemCount: news.length,
                itemBuilder: (context, i) {
                  var _news = news[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryDetails,
                        arguments: {'news': _news, 'catid': _news['catid']},
                      );
                    },
                    child: Container(
                      height: 200,
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.all(AppSizes.paddingSm),
                              child: Text(
                                _news['title'] ?? '',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                _userSharePreferences.removeBookMark(
                                    _news['id'], _news);
                                news.removeAt(i);
                                setState(() {});
                              },
                              icon: Icon(Icons.bookmark_added,
                                  color: Colors.white))
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: AppColors.accentColor,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.7),
                                  BlendMode.dstATop),
                              image:
                                  NetworkImage(_news['media'].first['path'])),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  );
                }),
      ),
    );
  }
}
