import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/ui/shared/news_page_view.dart';

class PollScreen extends StatelessWidget {
  final int position;
  PollScreen({this.position});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
        centerTitle: true,
        title: Text(
          'Poll',
        ),
      ),
      body: FutureBuilder(
        future: NewsService.getNewsType('poll', 20),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Somethings went wrong.."),
            );
          }
          if (snapshot.hasData) {
            List<News> news = snapshot.data;
            return NewsPageView(
              news: news,
              position: position,
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
