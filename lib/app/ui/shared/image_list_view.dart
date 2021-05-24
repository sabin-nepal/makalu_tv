import 'package:flutter/material.dart';

class ImageListView extends StatefulWidget {
  final String title;
  final String content;
  final String image;
  final String excerpt;
  final bool isFullContent;
  ImageListView({this.title,this.image,this.content,this.excerpt,this.isFullContent:false});

  @override
  _ImageListViewState createState() => _ImageListViewState();
}

class _ImageListViewState extends State<ImageListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.image!=null)Image.network(widget.image),
        Text(
          widget.title,
          textAlign: TextAlign.left ,
        ),
        Text(widget.content)
      ],
    );
  }
}