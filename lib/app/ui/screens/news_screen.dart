import 'package:flutter/material.dart';
import 'package:makalu_tv/app/managers/news_manager.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/styles/colors.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: NewsManager().newsListView,
      builder: (context, snapshot) {
        print(snapshot);
        List<News> news = snapshot.data;
        return ListView.separated(
          itemCount: news.length,
          itemBuilder: (context,index){
            print(news[index].title);
            return Container();
          },
          separatorBuilder: (context, index) => Divider(),
        );
      }
    );
  }
}