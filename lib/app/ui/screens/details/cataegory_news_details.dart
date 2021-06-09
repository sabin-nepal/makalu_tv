import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/ui/shared/news_page_item.dart';

class CategoryNewsDetails extends StatelessWidget {
  final Map news;
  CategoryNewsDetails({this.news});
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
          title: news['title'],
          content: news['content'],
          media: news['media'],
          isFullContent: true,
        ),
      ),
    );
  }
}
