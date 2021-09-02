import 'dart:convert';

import 'package:makalu_tv/app/core/url.dart';
import 'package:makalu_tv/app/models/advertisment.dart';
import 'package:http/http.dart' as http;

class AdvService {
  static Future<List<Advertisement>> getAdv(
      {var size = 50, var page = 0, var type = ""}) async {
        var uri = Uri(
      scheme: 'https',
      host: UrlHelper.url,
      path: '/api/v1/adv',
      queryParameters: {
        'type': type,
        'size': size.toString(),
        'page': page.toString(),
      },
    );
    final _res = await http.get(uri);
    if (_res.statusCode == 200) {
      final _decoded = jsonDecode(_res.body);
      final _data = _decoded
          .map<Advertisement>((e) => Advertisement.fromJson(e))
          .toList();
      return _data;
    }
    throw _res;
  }
}
