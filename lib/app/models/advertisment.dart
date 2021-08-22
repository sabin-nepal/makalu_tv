import 'package:flutter/material.dart';

class Advertisement {
  final String id;
  final String title;
  final String type;
  final Map media;
  final String position;
  Advertisement({
    @required this.id,
    @required this.title,
    this.type,
    this.media,
    this.position,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'],
      media: json['medium'],
      position: json['position'],
    );
  }
}
