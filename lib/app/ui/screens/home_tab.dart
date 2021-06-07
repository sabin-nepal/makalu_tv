import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
import 'package:makalu_tv/app/ui/shared/primary_card.dart';
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
    _categoryService = CategoryService.getCategoryNews();
    _newsService = NewsService.getNewsType('poll', 5);
  }

  List<Widget> indicator() {
    var _list = [];
    for (var i = 0; i < 10; i++) {
      _list.add('hello');
    }
    return _list;
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
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            ),
            IconButton(
              icon: Icon(Icons.bookmark),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(AppSizes.padding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: AppSizes.padding),
                        child: Text(
                          "Insight",
                          style: titleText,
                        )),
                  ],
                ),
                Container(height: 200.0, child: _buildInsight(context)),
                SizedBox(height: 50),
                Container(
                    margin: EdgeInsets.only(left: AppSizes.padding),
                    child: Text(
                      "Category",
                      style: titleText,
                    )),
                SizedBox(height: 20),
                Container(height: 500, child: _buildCategory(context)),
                SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.only(left: AppSizes.padding),
                    child: Text(
                      "Poll",
                      style: titleText,
                    )),
                Container(height: 400, child: _buildPoll(context)),
              ],
            ),
          ),
        ));
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
                shrinkWrap: true,
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
            return ListView.builder(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final _news = snapshot.data[index];
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: PrimaryCard(
                    news: _news,
                  ),
                );
              },
            );
          }
          return Container();
        });
  }
}
