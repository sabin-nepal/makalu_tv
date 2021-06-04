import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class NewsPageItem extends StatefulWidget {
  final String title;
  final String content;
  final List media;
  final String excerpt;
  final bool isFullContent;
  NewsPageItem(
      {this.title,
      this.media,
      this.content,
      this.excerpt,
      this.isFullContent: false});

  @override
  _NewsPageItemState createState() => _NewsPageItemState();
}

class _NewsPageItemState extends State<NewsPageItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: Card(
              child: PhotoViewGallery.builder(
            itemCount: widget.media.length,
            builder: (context, i) {
              var _media = widget.media[i];
              return PhotoViewGalleryPageOptions.customChild(
                  disableGestures: true,
                  initialScale: PhotoViewComputedScale.contained * 2.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.fullImage,
                        arguments: {'imageUrl': _media['path']},
                      );
                    },
                    child: CachedNetworkImage(imageUrl: _media['path']),
                  ));
            },
          )),
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
