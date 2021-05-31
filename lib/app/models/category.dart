import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final String type;
  final Map media;
  final List news;
  Category({
    @required this.id,
    @required this.title,
    this.media,
    this.type,
    this.news,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      title: json['title'] as String,
      media: json['medium'],
      type: json['type'] as String,
      news: json['news'],
    );
  }
}
