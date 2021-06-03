import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/ui/shared/news_page_item.dart';
import 'package:stacked_page_view/stacked_page_view.dart';

class NewsPageView extends StatelessWidget {
  final PageController pageController;
  final List<News> news;
  NewsPageView({this.pageController, this.news});
  @override
  Widget build(BuildContext context) {
    var currentPageValue = 0.0;
    return Container(
      child: PageView.builder(
        controller: pageController,
        pageSnapping: true,
        scrollDirection: Axis.vertical,
        itemCount: news.length,
        itemBuilder: (context, position) {
          News _news = news[position];
          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.primaryDelta < 0) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.newsDetails,
                  arguments: {'news': _news},
                );
              }
            },
            child: StackPageView(
              index: position,
              controller: pageController,
              child: NewsPageItem(
                title: _news.title,
                content: _news.content,
                excerpt: _news.excerpt,
                media: _news.media,
              ),
            ),
          );
        },
      ),
    );
  }
}
