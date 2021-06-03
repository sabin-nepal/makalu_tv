import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/helpers/news_helper.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/ui/shared/custom_list_item.dart';
import 'package:makalu_tv/app/ui/shared/news_page_view.dart';
import 'package:stacked_page_view/stacked_page_view.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final PageController pageController = PageController();
  final _newsHelper = NewsHelper();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _newsHelper.newsListView,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<News> news = snapshot.data;
            return NewsPageView(
              news: news,
              pageController: pageController,
            );
          }
        });
  }
}
