
import 'dart:async';

import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';

class NewsHelper{
  final StreamController<int> _newsCount = StreamController<int>();
  Stream<int> get newsCount =>_newsCount.stream;

  Stream<List<News>> get newsListView async*{
    yield await NewsService.getNews();
  } 

  NewsHelper(){
    newsListView.listen((event) => _newsCount.add(event.length));
  }

}