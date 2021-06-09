import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/ui/shared/custom_stack_page_view.dart';
import 'package:makalu_tv/app/ui/shared/news_page_item.dart';
import 'package:makalu_tv/app/ui/shared/poll_view.dart';

class CategoryPageView extends StatelessWidget {
  final List news;
  CategoryPageView({this.news});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return Container(
      child: PageView.builder(
        controller: pageController,
        pageSnapping: true,
        scrollDirection: Axis.vertical,
        itemCount: news.length,
        itemBuilder: (context, position) {
          var _news = news[position];
          return Column(
            children: [
              Flexible(
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (details.primaryDelta < 0) {}
                  },
                  child: CustomStackPageView(
                    index: position,
                    controller: pageController,
                    child: NewsPageItem(
                      title: _news['title'],
                      content: _news['content'],
                      excerpt: _news['excerpt'],
                      media: _news['media'],
                    ),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: AppSizes.padding),
                  alignment: _news['type'] == 'poll'
                      ? Alignment.topLeft
                      : Alignment.bottomCenter,
                  child: Text('Swipe for details')),
              SizedBox(height: 20),
              if (_news['type'] == 'poll')
                PollView(
                  title: _news['title'],
                  id: _news['id'],
                  noCount: _news['noCount'],
                  yesCount: _news['yesCount'],
                ),
            ],
          );
        },
      ),
    );
  }
}
