import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/news_helper.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/ui/shared/news_page_view.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  
  final _newsHelper = NewsHelper();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _newsHelper.newsListView,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Check your connection and try again..'));
          } else {
            List<News> news = snapshot.data;
            return NewsPageView(
              news: news,
            );
          }
        });
  }
}
