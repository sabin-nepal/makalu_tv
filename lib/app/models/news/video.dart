import 'package:flutter/material.dart';

class Video {
  final String id;
  final String title;
  final Map media;
  final Map thumbnail;
  final List category;
  final String type;
  final Map medium;
  Video({
    @required this.id,
    @required this.title,
    this.media,
    this.thumbnail,
    this.category,
    this.type,
    this.medium,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String,
      title: json['title'] as String,
      media: json['media'],
      medium: json['medium'],
      thumbnail: json['thumbnail'],
      category: json['categories'],
      type: json['type'] ?? 'video',
    );
  }
}
