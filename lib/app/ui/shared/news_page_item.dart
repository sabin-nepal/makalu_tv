import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/media.dart';
import 'package:makalu_tv/app/styles/styles.dart';

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
            child: CarouselSlider.builder(
              options: CarouselOptions(
                autoPlay: false,
                enableInfiniteScroll: false,
                aspectRatio: 2.0,
                viewportFraction: 1,
                enlargeCenterPage: true,
              ),
              itemCount: widget.media.length??1,
              itemBuilder: (ctx, index, realIdx) {
                var _media = widget.media[index];
                return Container(
                  child: CachedNetworkImage(
                    imageUrl: _media['path'],
                    fit: BoxFit.fill,
                  ),
                );
              },
            ),
          ),
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
