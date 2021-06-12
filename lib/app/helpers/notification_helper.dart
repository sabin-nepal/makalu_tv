
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';

class NotificationHelper{
  parseNotification(BuildContext context, Map message) async {
    
    final id = message['id'];
    final news = await NewsService.getSingleNews(id);
    Navigator.pushNamed(
      context,
      AppRoutes.newsDetails,
      arguments: {'news': news},
    );
  }
}