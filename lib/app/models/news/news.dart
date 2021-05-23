import 'package:flutter/material.dart';

class News{

  final String id;
  final String title; 
  News({
    @required this.id,
    @required this.title,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as String,
      title: json['title'] as String,
    );
  }

}