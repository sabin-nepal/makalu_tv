import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:photo_view/photo_view.dart';

class FullImageView extends StatelessWidget {
  final String imageUrl;
  FullImageView({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25),
            alignment: Alignment.topLeft,
            color: Colors.black,
            height: 50,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.cancel,
                color: AppColors.bgColor.withOpacity(0.5),
                size: 40,
              ),
            ),
          ),
          Expanded(
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
            ),
          ),
        ],
      ),
    );
  }
}
