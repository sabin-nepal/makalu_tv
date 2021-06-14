import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class NewsPageItem extends StatelessWidget {
  final String catid;
  final String title;
  final String content;
  final List media;
  final String excerpt;
  final bool isFullContent;
  NewsPageItem(
      {this.catid,
      this.title,
      this.media,
      this.content,
      this.excerpt,
      this.isFullContent: false});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            child: Card(
                child: PhotoViewGallery.builder(
              itemCount: media.length,
              builder: (context, i) {
                var _media = media[i];
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
                  title,
                  style: boldText,
                ),
                isFullContent ? Text(content) : Text(excerpt)
              ],
            ),
          ),
          if (isFullContent) _similarNewsHeading(),
          if (isFullContent) Container(height: 300, child: _similarNews()),
        ],
      ),
    );
  }

  Widget _similarNewsHeading() {
    return Column(
      children: [
        Divider(),
        SizedBox(height: 20),
        Row(children: <Widget>[
          Expanded(
              child: Divider(
            color: AppColors.primaryColor,
            thickness: 2,
          )),
          Text(
            "News to read",
            style: headingStyle,
          ),
          Expanded(
              child: Divider(
            color: AppColors.primaryColor,
            thickness: 2,
          )),
        ]),
      ],
    );
  }

  Widget _similarNews() {
    return FutureBuilder(
        future: NewsService.getCategoryNews(catid, 3),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData)
            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  News news = snapshot.data[i];
                  return Container(
                    margin: EdgeInsets.all(AppSizes.padding),
                    width: MediaQuery.of(context).size.width / 3,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.newsDetails,
                          arguments: {'news': news},
                        );
                      },
                      child: Column(
                        children: [
                          Card(
                            child: CachedNetworkImage(
                              imageUrl: news.media.first['path'],
                            ),
                          ),
                          Text(news.title, style: boldText),
                        ],
                      ),
                    ),
                  );
                });
          return Text('Connection Failed.');
        });
  }
}
