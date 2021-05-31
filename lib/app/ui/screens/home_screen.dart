import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/feed_item.dart';
import 'package:makalu_tv/app/models/category.dart';
import 'package:makalu_tv/app/models/news/insight.dart';
import 'package:makalu_tv/app/models/news/news.dart';
import 'package:makalu_tv/app/services/category_service.dart';
import 'package:makalu_tv/app/services/news/insight_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:makalu_tv/app/ui/shared/category_tab_view.dart';
import 'package:makalu_tv/app/ui/shared/search_bar.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future _insightService;
  Future _categoryService;
  int selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    _insightService = InsightService.getInsight();
    _categoryService = CategoryService.getCategoryNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(AppSizes.padding),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 100, child: _buildFeed(context)),
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
            SizedBox(height:20),
          ],
        ),
      ),
    ));
  }

  _buildFeed(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: feedItem.length,
        itemBuilder: (context, i) {
          final _item = feedItem[i];
          return Column(children: [
            IconButton(icon: _item.icon, onPressed: () {}),
            Text(_item.title),
          ]);
        });
  }

  Widget _buildSearch() {
    return TextField(
        onTap: () {
          showSearch(context: context, delegate: DataSearch());
        },
        readOnly: true,
        decoration: InputDecoration(
          border: new OutlineInputBorder(
              borderSide: new BorderSide(
                  style: BorderStyle.solid, color: Colors.white)),
          hintText: 'Search...',
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.accentColor,
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
                          child:
                              InkWell(onTap: () {}, child: Text("View All",style: boldText,))),
                    );
                  }
                  final _data = _insight[i];
                  return Container(
                    padding: EdgeInsets.only(left: AppSizes.paddingSm),
                    child: Card(
                        child: CachedNetworkImage(
                      imageUrl: _data.media.first['path'],
                      fit: BoxFit.cover,
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
}
