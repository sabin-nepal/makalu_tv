import 'package:flutter/material.dart';

class Insight {
  final String id;
  final List media;
  final Map background; 
  Insight({
    @required this.id,
    @required this.media,
    this.background,
  });

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      id: json['id'] as String,
      media: json['media'],
      background: json['background']
    );
  }
}
