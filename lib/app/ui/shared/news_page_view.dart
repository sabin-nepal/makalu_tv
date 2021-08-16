import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:makalu_tv/app/ui/shared/custom_stack_page_view.dart';
import 'package:makalu_tv/app/ui/shared/news_page_item.dart';
import 'package:makalu_tv/app/ui/shared/poll_view.dart';
import 'package:share/share.dart';

class NewsPageView extends StatefulWidget {
  final List news;
  final int position;
  final showRemaining;
  final pagination;
  final Function paginateQuery;
  NewsPageView(
      {this.news,
      this.position: 0,
      this.showRemaining: true,
      this.pagination: false,
      this.paginateQuery});

  @override
  _NewsPageViewState createState() => _NewsPageViewState();
}

class _NewsPageViewState extends State<NewsPageView> {
  PageController pageController;
  int remainingPage;
  bool _swipeVisible = false;
  FToast fToast;
  int _checked = 3;
  UserSharePreferences _userSharePreferences = UserSharePreferences();
  @override
  void initState() {
    super.initState();
    remainingPage = widget.news.length - 1;
    pageController = PageController(initialPage: widget.position);
    fToast = FToast();
  }

  _getFilters(var id) async {
    _checked = await _userSharePreferences.getFilter(id) ?? 2;
    var da = await _userSharePreferences.getFilterCategory();
    print(da);
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
        if (remainingPage == 10 && widget.pagination) {
          widget.paginateQuery();
        }
        setState(() {});
      },
      controller: pageController,
      pageSnapping: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.news.length,
      itemBuilder: (context, position) {
        var _news = widget.news[position];
        if (position.isOdd && _news.type == 'full') {
          return CustomStackPageView(
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
              ));
        }
        return Column(
          children: [
            Flexible(
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (details.primaryDelta < 0) {
                    Navigator.pushNamed(context, AppRoutes.newsDetails,
                        arguments: {'news': _news});
                  }
                },
                onTap: () {
                  setState(() {
                    _getFilters(_news.categories.first['id']);
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
                    newsUrl: _news.url,
                    content: _news.content,
                    excerpt: _news.excerpt,
                    media: _news.media,
                    onBookMark: (value) {
                      var setMessage;
                      if (value) {
                        setMessage = "Bookmark added";
                      } else {
                        setMessage = "Bookmark Removed";
                      }
                      setState(() {});
                      _showToast(context,
                          isBookMark: true, message: setMessage);
                    },
                  ),
                ),
              ),
            ),
            if (_swipeVisible)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () =>
                        _showBottomModel(context, _news.categories.first['id']),
                    icon: Icon(
                      Icons.circle,
                      color: _checked == 1
                          ? AppColors.allNewsColor
                          : _checked == 2
                              ? AppColors.majorNewsColor
                              : AppColors.noNewsColor,
                    ),
                  ),
                  Text(
                    'Swipe for details',
                    style: titleText,
                  ),
                  IconButton(
                      onPressed: () async {
                        await Share.share(
                          _news.url,
                          subject: _news.title,
                        );
                      },
                      icon: Icon(
                        Icons.share,
                        color: AppColors.iconColor,
                      ))
                ],
              ),
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

  void _showToast(BuildContext context,
      {var isBookMark = false, var message = ""}) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color(0xffff7000),
      ),
      child: Text(
        isBookMark
            ? message
            : remainingPage == 0
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

  void _showBottomModel(BuildContext context, var catId) {
    showModalBottomSheet(
        elevation: 2.0,
        backgroundColor: AppColors.bgColor,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () async {
                              await _userSharePreferences.saveFilter(catId, 1);
                              _checked = 1;
                              setState(() {});
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              _checked == 1
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              color: AppColors.allNewsColor,
                            )),
                        Text("All News", style: titleText)
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () async {
                              await _userSharePreferences.saveFilter(catId, 2);
                              _checked = 2;
                              setState(() {});
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              _checked == 2
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              color: AppColors.majorNewsColor,
                            )),
                        Text("Major News", style: titleText)
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () async {
                              await _userSharePreferences.saveFilter(catId, 3);
                              _checked = 3;
                              setState(() {});
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              _checked == 3
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                              color: AppColors.noNewsColor,
                            )),
                        Text("No News", style: titleText)
                      ],
                    ),
                  ],
                ),
                Center(
                  child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: AppColors.accentColor),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.filterScreen);
                      },
                      child: Text(
                        "All",
                        style: TextStyle(color: AppColors.bgColor),
                      )),
                )
              ],
            ),
          );
        });
  }
}
