import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/colors.dart';

class PollScreen extends StatelessWidget {
  final int position;
  PollScreen({this.position});
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
        centerTitle: true,
        title: Text(
          'Poll',
        ),
      ),
      
    );
  }
}
