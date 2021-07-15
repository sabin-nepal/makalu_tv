import 'package:flutter/material.dart';

class News {
  final String id;
  final String title;
  final String content;
  final String excerpt;
  final List media;
  final String type;
  final List categories;
  final String pollTitle;
  final Map pollResult;
  final String url;
  News({
    @required this.id,
    @required this.title,
    @required this.content,
    this.excerpt,
    this.type,
    this.media,
    this.categories,
    this.pollTitle,
    this.pollResult,
    this.url,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      url: json['url'] as String,
      media: json['media'],
      categories: json['categories'],
      type: json['type'] as String,
      pollTitle: json['pollTitle'] as String,
      excerpt: json['excerpt'] as String,
      pollResult: json['pollResult'],
    );
  }
}
