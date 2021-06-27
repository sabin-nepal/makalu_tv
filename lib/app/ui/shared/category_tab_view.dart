import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/routes.dart';
import 'package:makalu_tv/app/styles/styles.dart';

class CategoryTabView extends StatefulWidget {
  final List category;
  CategoryTabView({this.category});
  @override
  _CategoryTabViewState createState() => _CategoryTabViewState();
}

class _CategoryTabViewState extends State<CategoryTabView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this, length: widget.category.length, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: widget.category.map<Widget>((e) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryScreen,
                        arguments: {
                          'title': e.title ?? 'Category',
                          'catid': e.id,
                        },
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: e.media['path'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    e.title,
                    style: titleText,
                  )
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8.0),
        Expanded(
            child: TabBarView(
                controller: _tabController,
                children: widget.category.map((e) {
                  return ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: e.news.length > 4 ? 4 + 1 : e.news.length + 0,
                      itemBuilder: (context, i) {
                        var _news = e.news[i];
                        if (i == 4) {
                          return Center(
                              child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.categoryScreen,
                                arguments: {
                                  'title': e.title ?? 'Category',
                                  'catid': e.id
                                },
                              );
                            },
                            child: Text(
                              "View More",
                              style: boldText,
                            ),
                          ));
                        }
                        return ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.categoryDetails,
                              arguments: {'news': _news, 'catid': e.id},
                            );
                          },
                          title: AutoSizeText(
                            _news['title'],
                            maxLines: 2,
                            style: titleText,
                          ),
                          leading: CachedNetworkImage(
                            imageUrl: _news['media'].first['path'],
                          ),
                        );
                      });
                }).toList()))
      ],
    );
  }
}
