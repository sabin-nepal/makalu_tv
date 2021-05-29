import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:makalu_tv/app/core/url.dart';
import 'package:makalu_tv/app/models/news/insight.dart';

class InsightService{

 static Future<List<Insight>> getInsight() async{

    final _res = await http.get(Uri.parse(UrlHelper.insightUrl));
    if(_res.statusCode == 200){
      final _decoded = jsonDecode(_res.body);
      final _data = _decoded
          .map<Insight>((e) => Insight.fromJson(e))
          .toList();
      return _data;
    }
  throw _res;
 }

 Future<List<Insight>> getInsightLimit(int number) async{
   final _res = await http.get(Uri.parse('${UrlHelper.insightUrl}/limit/$number'));
   if(_res.statusCode == 200){
      final _decoded = jsonDecode(_res.body);
      final _data = _decoded
          .map<Insight>((e) => Insight.fromJson(e))
          .toList();
      return _data;
    }
  throw _res;
 }  

} 