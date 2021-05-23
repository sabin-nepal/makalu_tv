import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:makalu_tv/app/helpers/url.dart';
import 'package:makalu_tv/app/models/news/news.dart';

class NewsService{

 static Future<List<News>> getNews() async{

    final _res = await http.get(Uri.parse(UrlHelper.newsUrl));
    if(_res.statusCode == 200){
      final _decoded = jsonDecode(_res.body);
      final _data = _decoded
          .map<News>((e) => News.fromJson(e))
          .toList();
      return _data;
    }
  throw _res;
 }

} 