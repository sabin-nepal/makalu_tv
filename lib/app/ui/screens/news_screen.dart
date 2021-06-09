import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/ui/shared/category_page_view.dart';
import 'package:makalu_tv/app/ui/shared/news_page_view.dart';

class NewsScreen extends StatelessWidget {
  final String title;
  final String type;
  final List news;
  NewsScreen({this.title, this.type: 'category', this.news});
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
      body: type != 'category'
          ? NewsPageView(news: news)
          : CategoryPageView(news:news)
    );
  }
}
