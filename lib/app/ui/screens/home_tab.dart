import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/feed_item.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/models/category.dart';
import 'package:makalu_tv/app/models/news/insight.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/services/category_service.dart';
import 'package:makalu_tv/app/services/news/insight_service.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:makalu_tv/app/ui/shared/category_tab_view.dart';
import 'package:makalu_tv/app/ui/shared/poll_view.dart';
import 'package:makalu_tv/app/ui/shared/search_bar.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future _insightService;
  Future _categoryService;
  Future _newsService;
  int selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    _insightService = InsightService.getInsight();
    _categoryService = CategoryService.getCategoryNews(5);
    _newsService =
        NewsService.getNewsType(type: 'poll', limit: 5, offset: 0, order: true);
  }

  Future<void> _showSearch() async {
    await showSearch<String>(
      context: context,
      delegate: CustomSearch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
              decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
          centerTitle: true,
          title: Text(
            'Discover',
          ),
          leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settingScreen);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _showSearch();
              },
            ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(AppSizes.padding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 100.0, child: _newsCategory()),
                SizedBox(height: 10),
                Container(height: 120.0, child: _buildfeed(context)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: AppSizes.padding),
                        child: Text(
                          "Insight",
                          style: headingStyle,
                        )),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.insightScreen,
                            arguments: {'position': 0});
                      },
                      child: Text(
                        "view all",
                        style: boldText,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(height: 200.0, child: _buildInsight(context)),
                SizedBox(height: 40),
                Container(
                    margin: EdgeInsets.only(left: AppSizes.padding),
                    child: Text(
                      "Category",
                      style: headingStyle,
                    )),
                SizedBox(height: 10),
                Container(height: 450, child: _buildCategory(context)),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: AppSizes.padding),
                        child: Text(
                          "Poll",
                          style: headingStyle,
                        )),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.pollScreen,
                            arguments: {'position': 0});
                      },
                      child: Text(
                        "view all",
                        style: boldText,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(height: 350, child: _buildPoll(context)),
              ],
            ),
          ),
        ));
  }

  Widget _newsCategory() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.categoryScreen,
              arguments: {
                'title': 'Covid News',
                'catid': 'makalu&covidnews',
              },
            );
          },
          child: Container(
            width: 200,
            child: Card(
              color: AppColors.bgColor.withOpacity(0.9),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  Icons.add,
                  color: AppColors.accentColor,
                  size: 30,
                ),
                Text("Covid News", style: titleText),
              ]),
            ),
          ),
        )
      ],
    );
  }
  Widget _buildInsight(BuildContext context) {
    return FutureBuilder<List<Insight>>(
        future: _insightService,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.hasData) {
            final _insight = snapshot.data;
            return ListView.builder(
                physics: PageScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: _insight.length + 1,
                itemBuilder: (context, i) {
                  if (i == _insight.length) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Center(
                          child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.insightScreen,
                                  arguments: {'position': 0},
                                );
                              },
                              child: Text(
                                "View All",
                                style: boldText,
                              ))),
                    );
                  }
                  final _data = _insight[i];
                  return Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.only(left: AppSizes.paddingSm),
                    child: Card(
                        child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.insightScreen,
                          arguments: {'position': i},
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: _data.media.first['path'],
                        fit: BoxFit.cover,
                      ),
                    )),
                  );
                });
          }
          return Container();
        });
  }

  Widget _buildfeed(BuildContext context) {
    return ListView.builder(
      itemCount: feedItems.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, i) {
        FeedItem item = feedItems[i];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, item.key, arguments: item.data);
                },
                icon: item.icon,
                color: AppColors.accentColor,
                iconSize: 60,
              ),
              Text(
                item.title,
                style: titleText,
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategory(BuildContext context) {
    return FutureBuilder<List<Category>>(
        future: _categoryService,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CategoryTabView(
              category: snapshot.data,
            );
          }
          return Container();
        });
  }

  Widget _buildPoll(BuildContext context) {
    return FutureBuilder<List<News>>(
        future: _newsService,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.hasData) {
            final _poll = snapshot.data;
            return PageView.builder(
              itemCount: _poll.length,
              itemBuilder: (context, index) {
                final _news = _poll[index];
                return Card(
                  color: AppColors.bgColor,
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.padding),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.pollScreen,
                                  arguments: {'position': index});
                            },
                            child: CachedNetworkImage(
                              imageUrl: _news.media.first['path'],
                              fit: BoxFit.cover,
                            ),
                          )),
                      SizedBox(height: 20),
                      PollView(
                        title: _news.pollTitle,
                        id: _news.id,
                        yesCount: _news.pollResult['yesCount'],
                        noCount: _news.pollResult['noCount'],
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Container();
        });
  }
}
