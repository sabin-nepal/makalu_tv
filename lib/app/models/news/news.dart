import 'package:flutter/material.dart';

class News {
  final String id;
  final String title;
  final String content;
  final String excerpt;
  final List media;
  final String type;
  final String pollTitle;
  final Map pollResult;
  News({
    @required this.id,
    @required this.title,
    @required this.content,
    this.excerpt,
    this.type,
    this.media,
    this.pollTitle,
    this.pollResult,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      media: json['media'],
      type: json['type'] as String,
      pollTitle: json['pollTitle'] as String,
      excerpt: json['excerpt'] as String,
      pollResult: json['pollResult'],
    );
  }
}
