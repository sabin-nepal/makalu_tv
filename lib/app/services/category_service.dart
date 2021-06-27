import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:makalu_tv/app/core/url.dart';
import 'package:makalu_tv/app/models/category.dart';

class CategoryService {
  static Future<List<Category>> getCategory() async {
    final _res = await http.get(Uri.parse(UrlHelper.categoryUrl));
    if (_res.statusCode == 200) {
      final _decoded = jsonDecode(_res.body);
      final _data =
          _decoded.map<Category>((e) => Category.fromJson(e)).toList();
      return _data;
    }
    throw _res;
  }

  static Future<List<Category>> getCategoryNews(int limit) async {
    final _res =
        await http.get(Uri.parse('${UrlHelper.categoryNewsUrl}/$limit'));
    if (_res.statusCode == 200) {
      final _decoded = jsonDecode(_res.body);
      final _data = _decoded.map<Category>((e) => Category.fromJson(e)).toList();
      return _data;
    }
    throw _res;
  }
}
