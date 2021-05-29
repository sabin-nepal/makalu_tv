import 'package:flutter/material.dart';

class FeedItem {
  final Icon icon;
  final String title;

  FeedItem({this.icon, this.title});
}

final List<FeedItem> feedItem = [
  FeedItem(icon:Icon(Icons.auto_stories),title: "All News"),
  FeedItem(icon:Icon(Icons.local_fire_department),title: "Trending"),
  FeedItem(icon:Icon(Icons.bookmark),title: "Bookmarks"),
];