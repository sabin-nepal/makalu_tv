import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/styles.dart';

class ImageListView extends StatefulWidget {
  final String title;
  final String content;
  final String image;
  final String excerpt;
  final bool isFullContent;
  ImageListView(
      {this.title,
      this.image,
      this.content,
      this.excerpt,
      this.isFullContent: false});

  @override
  _ImageListViewState createState() => _ImageListViewState();
}

class _ImageListViewState extends State<ImageListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.image != null)
          InkWell(
            child: Image.network(widget.image, fit: BoxFit.fitWidth),
            onTap: () {
              print(widget.image);
            },
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: boldText,
              ),
              widget.isFullContent ? Text(widget.content) : Text(widget.excerpt)
            ],
          ),
        ),
      ],
    );
  }
}
