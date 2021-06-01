import 'package:flutter/material.dart';

class News {
  final String id;
  final String title;
  final String content;
  final String excerpt;
  final List media;
  final Map pollResult;
  News({
    @required this.id,
    @required this.title,
    @required this.content,
    this.excerpt,
    this.media,
    this.pollResult,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      media: json['media'],
      excerpt: json['excerpt'] as String,
      pollResult: json['pollResult'],
    );
  }
}
