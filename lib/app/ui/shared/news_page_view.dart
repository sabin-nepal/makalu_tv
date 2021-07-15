import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:makalu_tv/app/ui/shared/custom_stack_page_view.dart';
import 'package:makalu_tv/app/ui/shared/news_page_item.dart';
import 'package:makalu_tv/app/ui/shared/poll_view.dart';

class NewsPageView extends StatefulWidget {
  final List news;
  final int position;
  final showRemaining;
  final String type;
  NewsPageView(
      {this.news, this.position: 0, this.showRemaining: true, this.type});

  @override
  _NewsPageViewState createState() => _NewsPageViewState();
}

class _NewsPageViewState extends State<NewsPageView> {
  PageController pageController;
  int remainingPage;
  bool _swipeVisible = false;
  FToast fToast;
  int currentpage = 1;
  @override
  void initState() {
    super.initState();
    remainingPage = widget.news.length - 1;
    pageController = PageController(initialPage: widget.position);
    fToast = FToast();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    return PageView.builder(
      onPageChanged: (index) {
        int value = index + 1;
        remainingPage = widget.news.length - value;
        _swipeVisible = false;
        setState(() {});
        if (remainingPage == 5) {
          print(currentpage);
          _paginationQuery();
        }
      },
      controller: pageController,
      pageSnapping: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.news.length,
      itemBuilder: (context, position) {
        var _news = widget.news[position];
        if (position.isOdd && _news.type == 'full') {
          return InkWell(
            onTap: () => _showToast(context),
            child: CustomStackPageView(
                controller: pageController,
                index: position,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(_news.media['path']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Center(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppSizes.padding),
                        child: CachedNetworkImage(
                            imageUrl: _news.media['path'], fit: BoxFit.fill),
                      ),
                    ),
                  ),
                )),
          );
        }
        return Column(
          children: [
            Flexible(
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
                onTap: () {
                  setState(() {
                    _swipeVisible = true;
                  });
                  if (widget.showRemaining) _showToast(context);
                },
                child: CustomStackPageView(
                  index: position,
                  controller: pageController,
                  initial: widget.position,
                  child: NewsPageItem(
                    catid: _news.categories.first['id'] ?? '',
                    title: _news.title,
                    newsId: _news.id,
                    content: _news.content,
                    excerpt: _news.excerpt,
                    media: _news.media,
                  ),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: AppSizes.padding),
                alignment: Alignment.bottomCenter,
                child: Text(
                  _swipeVisible ? 'Swipe for details' : '',
                  style: titleText,
                )),
            SizedBox(height: 20),
            if (_news.type == 'poll')
              PollView(
                title: _news.pollTitle,
                id: _news.id,
                yesCount: _news.pollResult['yesCount'],
                noCount: _news.pollResult['noCount'],
              ),
          ],
        );
      },
    );
  }

  _paginationQuery() {
    if (widget.type == 'news') {
      NewsService.getNewsType(
              type: "", limit: 1, offset: currentpage, order: true)
          .then((val) {
        print(val);
        currentpage++;
        setState(() {
          widget.news.addAll(val);
        });
      });
    }
  }

  void _showToast(BuildContext context) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color(0xffff7000),
      ),
      child: Text(
        remainingPage == 0
            ? 'No More News Refresh For New one'
            : '$remainingPage news remaining',
      ),
    );
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (_, child) {
          return Positioned(
            child: child,
            bottom: MediaQuery.of(context).size.height / 3.5,
            left: 16.0,
            right: 16.0,
          );
        });
  }
}
