import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/ui/shared/news_page_item.dart';
import 'package:stacked_page_view/stacked_page_view.dart';

class NewsPageView extends StatefulWidget {
  final List<News> news;
  NewsPageView({this.news});

  @override
  _NewsPageViewState createState() => _NewsPageViewState();
}

class _NewsPageViewState extends State<NewsPageView> {
  final PageController pageController = PageController();
  int remainingPage;
  @override
  void initState() {
    super.initState();
    remainingPage = widget.news.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView.builder(
        onPageChanged: (index) {
          int value = index + 1;
          remainingPage = widget.news.length - value;
          setState(() {});
        },
        controller: pageController,
        pageSnapping: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.news.length,
        itemBuilder: (context, position) {
          News _news = widget.news[position];
          return Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (details.primaryDelta < 0) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.newsDetails,
                        arguments: {'news': _news},
                      );
                    }
                  },
                  onTap: () => _showToast(context),
                  child: StackPageView(
                    index: position,
                    controller: pageController,
                    child: NewsPageItem(
                      title: _news.title,
                      content: _news.content,
                      excerpt: _news.excerpt,
                      media: _news.media,
                    ),
                  ),
                ),
              ),
              Text("Swipe Left for More Details"),
            ],
          );
        },
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryColor,
        duration: Duration(milliseconds: 1000),
        content: Text(remainingPage==0 ? 'No More News Refresh For New one' :'$remainingPage news is remaining'),
      ),
    );
  }
}
