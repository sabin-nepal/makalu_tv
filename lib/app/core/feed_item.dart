import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';

class FeedItem {
  final String title;
  final Icon icon;
  final String key;

  FeedItem({this.title, this.icon, this.key});
}

final List<FeedItem> feedItems = [
  FeedItem(icon: Icon(Icons.book), title: "My feed"),
  FeedItem(icon: Icon(Icons.chrome_reader_mode), title: "All News"),
  FeedItem(icon: Icon(Icons.star), title: "Top Stories"),
  FeedItem(icon: Icon(Icons.local_fire_department), title: "Trending"),
  FeedItem(
      icon: Icon(Icons.bookmark),
      title: "Bookmarks",
      key: AppRoutes.bookMarkScreen),
  FeedItem(icon: Icon(Icons.visibility_off), title: "Unread"),
];
