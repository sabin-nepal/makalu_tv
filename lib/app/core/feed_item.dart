import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';

class FeedItem {
  final String title;
  final Icon icon;
  final String key;
  final Map data;

  FeedItem({this.title, this.icon, this.key, this.data});
}

final List<FeedItem> feedItems = [
  FeedItem(
      icon: Icon(Icons.book),
      title: "My feed",
      key: AppRoutes.newsScreen,
      data: {
        'title': "My Feed",
        'type': "feed",
      }),
  FeedItem(
      icon: Icon(Icons.chrome_reader_mode),
      title: "All News",
      key: AppRoutes.newsScreen,
      data: {
        'title': "All News",
        'type': "news",
      }),
  FeedItem(
      icon: Icon(Icons.star),
      title: "Top Stories",
      key: AppRoutes.newsScreen,
      data: {
        'title': "Top Stories",
        'type': "top",
      }),
  FeedItem(
      icon: Icon(Icons.local_fire_department),
      title: "Trending",
      key: AppRoutes.newsScreen,
      data: {
        'title': "Trending",
        'type': "trending",
      }),
  FeedItem(
      icon: Icon(Icons.bookmark),
      title: "Bookmarks",
      key: AppRoutes.bookMarkScreen),
  FeedItem(
      icon: Icon(Icons.visibility_off),
      title: "Unread",
      key: AppRoutes.newsScreen,
      data: {
        'title': "Unread",
        'type': "unread",
      }),
];
