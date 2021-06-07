import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/news/insight.dart';

class InsightItemView extends StatelessWidget {
  final Insight insight;
  InsightItemView({this.insight});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(insight.background['path']),
          fit: BoxFit.cover,
        ),
      ),
      child: PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: insight.media.length,
          itemBuilder: (context, index) {
            var media = insight.media[index];
            return CachedNetworkImage(
              imageUrl: media['path'],
              width: MediaQuery.of(context).size.width,
            );
          }),
    );
  }
}
