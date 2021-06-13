import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:makalu_tv/app/core/url.dart';
import 'package:makalu_tv/app/models/news/news.dart';

class NewsService {
  static Future<List<News>> getNews() async {
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

  static Future<List<News>> getNewsType(String type, int limit) async {
    final _res =
        await http.get(Uri.parse('${UrlHelper.newsTypeUrl}/$type/$limit'));
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
