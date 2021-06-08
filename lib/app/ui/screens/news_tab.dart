import 'dart:async';

import 'package:flutter/material.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/ui/shared/news_page_view.dart';

class NewsTab extends StatefulWidget {
  final List adv;
  NewsTab({this.adv});
  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  int _newsLength;
  int _newNews = 0;
  @override
  void initState() {
    super.initState();
    //_checkNews();
  }

  Future<void> _refreshNews(BuildContext context) async {
    var _news = await NewsService.getNews();
    return _news;
  }

  _mergeList(List news) {
    List _news = List.from(news);
    if (widget.adv.isNotEmpty) {
      var j = 0;
      for (var i = 0; i < _news.length; i++) {
        if (i % 2 == 1 && widget.adv.length > j) {
          _news.insert(i, widget.adv[j]);
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
                setState(() {});
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
          child: FutureBuilder(
              future: NewsService.getNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Check your connection and try again..'));
                }
                if (snapshot.hasData) {
                  List news = _mergeList(snapshot.data);
                  _newsLength = news.length;
                  return NewsPageView(
                    news: news,
                  );
                }
                return Center(child: CircularProgressIndicator());
              }),
        ));
  }
}
