import 'package:flutter/material.dart';

class Video {
  final String id;
  final String title;
  final List media;
  final List category;
  Video({
    @required this.id,
    @required this.title,
    this.media,
    this.category,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String,
      title: json['title'] as String,
      media: json['media'],
      category: json['category'],
    );
  }
}
