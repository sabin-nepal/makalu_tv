import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';

class NewsNotifier extends ChangeNotifier {
  Map poll;
  Map get getPolls => poll;
  fetchPolls(String id) async {
    poll = await NewsService.getVote(id);
    notifyListeners();
  }
}
