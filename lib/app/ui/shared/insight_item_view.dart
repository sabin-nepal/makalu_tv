import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/news/insight.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class InsightItemView extends StatelessWidget {
  final Insight insight;
  InsightItemView({this.insight});
  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(insight.background != null
              ? insight.background['path']
              : insight.media.first['path']),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Stack(
          children: [
            PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: insight.media.length,
                itemBuilder: (context, index) {
                  var media = insight.media[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.padding),
                    child: CachedNetworkImage(
                      imageUrl: media['path'],
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                }),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.padding),
                  child: Center(
                      child: SmoothPageIndicator(
                          controller: _pageController,
                          count: insight.media.length)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
