import 'package:flutter/material.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/ui/shared/news_page_view.dart';
import 'package:makalu_tv/app/ui/shared/page_pagination.dart';

class CategoryScreen extends StatelessWidget {
  final String title;
  final String catid;
  CategoryScreen({this.title, this.catid});
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
        body: FutureBuilder(
          future: NewsService.getCategoryNews(id: catid, limit: 20),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              var news = snapshot.data;
              return PagePagination(
                news: news,
                id: catid,
                limit: 20,
                type: 'category',
              );
            }
            return Container();
          },
        ));
  }
}
