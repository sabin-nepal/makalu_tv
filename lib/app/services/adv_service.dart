import 'dart:convert';

import 'package:makalu_tv/app/core/url.dart';
import 'package:makalu_tv/app/models/advertisment.dart';
import 'package:http/http.dart' as http;

class AdvService {
  static Future<List<Advertisement>> getAdv() async {
    final _res = await http.get(Uri.parse(UrlHelper.advUrl));
    if (_res.statusCode == 200) {
      final _decoded = jsonDecode(_res.body);
      final _data =
          _decoded.map<Advertisement>((e) => Advertisement.fromJson(e)).toList();
      return _data;
    }
    throw _res;
  }
}
