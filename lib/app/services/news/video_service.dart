import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:makalu_tv/app/core/url.dart';
import 'package:makalu_tv/app/models/news/video.dart';

class VideoService{

  static Future<List<Video>> getVideo(var page) async{

    final _res = await http.get(Uri.parse('${UrlHelper.videoNewsUrl}?size=4&page=$page'));
    if(_res.statusCode == 200){
      final _decoded = jsonDecode(_res.body);
      final _data = _decoded
          .map<Video>((e) => Video.fromJson(e))
          .toList();
      return _data;
    }
  throw _res;
 }
}