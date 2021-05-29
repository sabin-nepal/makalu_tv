import 'package:flutter/material.dart';

class Media {
  final String id;
  final String path;
  final String type;
  Media({
    @required this.id,
    @required this.path,
    @required this.type,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] as String,
      path: json['path'] as String,
      type: json['type'] as String,
    );
  }
}
