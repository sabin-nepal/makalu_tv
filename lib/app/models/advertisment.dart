import 'package:flutter/material.dart';

class Advertisement {
  final String id;
  final String title;
  final String content;
  final String excerpt;
  final List media;
  final Map pollResult;
  Advertisement({
    @required this.id,
    @required this.title,
    @required this.content,
    this.excerpt,
    this.media,
    this.pollResult,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      media: json['media'],
      excerpt: json['excerpt'] as String,
      pollResult: json['pollResult'],
    );
  }
}
