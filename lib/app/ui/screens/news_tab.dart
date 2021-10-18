import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:makalu_tv/app/ui/shared/news_page_view.dart';

class NewsTab extends StatefulWidget {
  final List adv;
  NewsTab({this.adv});
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  //int _newsLength;
  int _newNews = 0;
  List _allNews = [];
  bool _isLoading = true;
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() async {
    var _linkId = await UserSharePreferences().dynamicLinkId();
    try {
      var news =
          await NewsService.getNewsType(limit: 95, order: true, id: _linkId);
      _allNews = _mergeList(news);
    } on SocketException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(left: 100, right: 100),
        content: Text("Connection Failed"),
      ));
    }
    _isLoading = false;
    await UserSharePreferences().removeDynamicLinkId();
    setState(() {});
  }

  Future<void> _refreshNews(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _fetchData();
    });
  }

  _mergeList(List news) {
    List _news = List.from(news);
    if (widget.adv.isNotEmpty) {
      var j = 0;
      for (var i = 0; i < _news.length; i++) {
        if (i % 2 == 1 && widget.adv.length > j) {
          if (widget.adv[j].type == 'full') _news.insert(i, widget.adv[j]);
          j++;
        }
      }
    }
    return _news;
  }

  // _checkNews() async {
  //   Timer.periodic(Duration(seconds: 10), (Timer timer) {
  //     var _news = NewsService.getNews();
  //     _news.then((value) {
  //       if (value.length > _newsLength) {
  //         _newNews = value.length - _newsLength;
  //         setState(() {});
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
              decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
          centerTitle: true,
          title: Text(
            'News',
          ),
          actions: [
            Center(child: Text(_newNews > 0 ? _newNews.toString() : '')),
            IconButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _fetchData();
                });
              },
              icon: Icon(
                Icons.refresh,
                color: AppColors.bgColor,
              ),
            )
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () => _refreshNews(context),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _allNews.isEmpty
                    ? Center(
                        child: Text(
                          "Error on connection..",
                          style: boldText,
                        ),
                      )
                    : NewsPageView(
                        news: _allNews,
                      )));
  }
}
