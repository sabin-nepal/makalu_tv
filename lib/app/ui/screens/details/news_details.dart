import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/ui/shared/news_page_item.dart';

class NewsDetails extends StatelessWidget {
  final News news;
  NewsDetails({this.news});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
              decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
          centerTitle: true,
          title: Text("News Detail")),
      body: SingleChildScrollView(
        child: NewsPageItem(
          catid: news.categories.first['id']??'',
          title: news.title,
          content: news.content,
          media: news.media,
          isFullContent: true,
        ),
      ),
    );
  }
}
