import 'package:flutter/material.dart';

class Advertisement {
  final String id;
  final String title;
  final String type;
  final Map media;
  Advertisement({
    @required this.id,
    @required this.title,
    this.type,
    this.media,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'],
      media: json['medium'],
    );
  }
}
