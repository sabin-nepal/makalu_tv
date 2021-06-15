import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class NewsPageItem extends StatefulWidget {
  final String catid;
  final String newsId;
  final String title;
  final String content;
  final List media;
  final String excerpt;
  final bool isFullContent;
  NewsPageItem(
      {this.catid,
      this.newsId,
      this.title,
      this.media,
      this.content,
      this.excerpt,
      this.isFullContent: false});

  @override
  _NewsPageItemState createState() => _NewsPageItemState();
}

class _NewsPageItemState extends State<NewsPageItem> {
  UserSharePreferences _userSharePreferences = UserSharePreferences();

  bool isBookMark = false;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  _checkBookmark() async {
    isBookMark = await _userSharePreferences.hasBookMark(widget.newsId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.title,
                    style: boldText,
                  ),
                ),
                if (!widget.isFullContent)
                  IconButton(
                    icon: Icon(isBookMark
                        ? Icons.bookmark_added
                        : Icons.bookmark_add_outlined),
                    onPressed: () async {
                      Map<String, dynamic> _news = {
                          'id': widget.newsId,
                          'catid': widget.catid,
                          'title': widget.title,
                          'media': widget.media,                          
                          'excerpt': widget.excerpt,
                          'content': widget.content,
                        };
                      if (isBookMark) {
                        await _userSharePreferences
                            .removeBookMark(widget.newsId,_news);
                      } else {
                        await _userSharePreferences.saveBookMark(
                            widget.newsId, _news);
                      }
                      isBookMark = !isBookMark;
                      setState(() {});
                    },
                  )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.isFullContent
                  ? Text(widget.content)
                  : Text(widget.excerpt)),
          if (widget.isFullContent) _similarNewsHeading(),
          if (widget.isFullContent)
            Container(height: 300, child: _similarNews()),
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
        SizedBox(height: 10),
      ],
    );
  }

  Widget _similarNews() {
    return FutureBuilder(
        future: NewsService.getCategoryNews(widget.catid, 3),
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
          return Center(child: Text('Connection Failed.'));
        });
  }
}
