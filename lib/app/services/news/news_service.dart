import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:makalu_tv/app/core/url.dart';
import 'package:makalu_tv/app/models/news/news.dart';

class NewsService {
  static Future<List<News>> getNews({int limit, int offset}) async {
    final _res = await http.get(Uri.parse(UrlHelper.newsUrl));
    if (_res.statusCode == 200) {
      final _decoded = jsonDecode(_res.body);
      final _data = _decoded.map<News>((e) => News.fromJson(e)).toList();
      return _data;
    }
    throw _res;
  }

  static Future<List<News>> getSingleNews(String id) async {
    final _res = await http.get(Uri.parse('${UrlHelper.newsUrl}/$id'));
    if (_res.statusCode == 200) {
      final _decoded = jsonDecode(_res.body);
      final _data = _decoded.map<News>((e) => News.fromJson(e)).toList();
      return _data;
    }
    throw _res;
  }

  static Future<List<News>> getNewsType(
      {String type, var limit, var offset, bool order}) async {
    final _res = await http.get(Uri.parse(
        '${UrlHelper.newsTypeUrl}?type=$type&size=$limit&page=$offset&order=${order ? order : ""}'));
    if (_res.statusCode == 200) {
      final _decoded = jsonDecode(_res.body);
      final _data = _decoded.map<News>((e) => News.fromJson(e)).toList();
      return _data;
    }
    throw _res;
  }

  static Future<List<News>> getDailyNews({String type}) async {
    final _res = await http.get(Uri.parse('${UrlHelper.newsUrl}/daily'));
    if (_res.statusCode == 200) {
      final _decoded = jsonDecode(_res.body);
      final _data = _decoded.map<News>((e) => News.fromJson(e)).toList();
      return _data;
    }
    throw _res;
  }

  static Future<List<News>> getSearchResult(String s) async {
    final _res = await http.get(Uri.parse('${UrlHelper.newsSearchUrl}/$s'));
    if (_res.statusCode == 200) {
      final _decoded = jsonDecode(_res.body);
      final _data = _decoded.map<News>((e) => News.fromJson(e)).toList();
      return _data;
    }
    throw _res;
  }

  static Future<List<News>> getCategoryNews(String id, int page,) async {
    final _res =
        await http.get(Uri.parse('${UrlHelper.newsCategoryUrl}/$id?page=$page'));
    if (_res.statusCode == 200) {
      final _decoded = jsonDecode(_res.body);
      final _data = _decoded.map<News>((e) => News.fromJson(e)).toList();
      return _data;
    }
    throw _res;
  }

  Future<News> setVote(String id, int choice) async {
    final response = await http.post(
      Uri.parse('${UrlHelper.newsUrl}/vote/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'choice': choice,
      }),
    );
    if (response.statusCode == 201) {
      return News.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to Vote.');
    }
  }

  static Future getVote(String id) async {
    final _res = await http.get(Uri.parse('${UrlHelper.newsUrl}/vote/$id'));
    if (_res.statusCode == 200) {
      final _decoded = jsonDecode(_res.body);
      return _decoded;
    }
    throw _res;
  }
}
