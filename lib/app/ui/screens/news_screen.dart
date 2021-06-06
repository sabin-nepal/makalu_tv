import 'dart:async';

import 'package:flutter/material.dart';
import 'package:makalu_tv/app/services/adv_service.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/ui/shared/news_page_view.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int _newsLength;
  int _newNews = 0;
  List _adv = [];
  @override
  void initState() {
    super.initState();
    //_checkNews();
    _fetchAdv();
  }

  _fetchAdv() async {
    var adv = await AdvService.getAdv();
    adv.forEach((element) {
      _adv.add(element);
    });
  }

  Future<void> _refreshNews(BuildContext context) async {
    var _news = await NewsService.getNews();
    return _news;
  }

  _mergeList(List news) {
    List _news = List.from(news);
    var j=0; 
    for (var i = 0; i < news.length; i++) {
      if (i % 2 == 1) {
        _news.insert(i, _adv[j]);
        j++;
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
                } else {
                  List news = _mergeList(snapshot.data);
                  _newsLength = news.length;
                  return NewsPageView(
                    news: news,
                  );
                }
              }),
        ));
  }
}
