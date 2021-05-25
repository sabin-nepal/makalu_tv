import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/helpers/news_helper.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/ui/shared/image_list_view.dart';
import 'package:stacked_page_view/stacked_page_view.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final PageController pageController = PageController();
  final _newsHelper = NewsHelper();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _newsHelper.newsListView,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<News> news = snapshot.data;
            return PageView.builder(
              controller: pageController,
              itemCount: news.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var _data = news[index];
                return GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (details.primaryDelta < 0) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.newsDetails,
                        arguments: {'news': _data},
                      );
                    }
                  },
                  child: StackPageView(
                    index: index,
                    controller: pageController,
                    child: ImageListView(
                      title: _data.title,
                      image: _data.thumbnail,
                      content: _data.content,
                      excerpt: _data.excerpt,
                    ),
                  ),
                );
              },
            );
          }
        });
  }
}
