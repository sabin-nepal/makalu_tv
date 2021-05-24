import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/news_helper.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/ui/shared/image_list_view.dart';

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: NewsHelper().newsListView,
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return Container() ;
        }
        List<News> news = snapshot.data;
        return ListView.separated(
          itemCount: news.length,
          itemBuilder: (context,index){
            var _data = news[index];
            return ImageListView(
              title: _data.title,
              image: _data.thumbnail,
              content: _data.content,
            );
          },
          separatorBuilder: (context, index) => Divider(),
        );
      }
    );
  }
}