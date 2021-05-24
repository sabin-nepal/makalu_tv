import 'package:flutter/material.dart';

class News{

  final String id;
  final String title;
  final String content;
  final String thumbnail;
  final String excerpt;
  News({
    @required this.id,
    @required this.title,
    @required this.content,
    this.thumbnail,
    this.excerpt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      thumbnail: json['thumbnail'] as String,
      excerpt: json['excerpt'] as String,
    );
  }

}