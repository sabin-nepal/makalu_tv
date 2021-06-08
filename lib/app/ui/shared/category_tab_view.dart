import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
                  Container(
                    child: CachedNetworkImage(
                      imageUrl: e.media['path'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(e.title)
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
                              child: Text(
                            "View More",
                            style: boldText,
                          ));
                        }
                        return ListTile(
                          title: AutoSizeText(
                            _news['title'],
                            maxLines: 2,
                          ),
                          trailing: CachedNetworkImage(
                            imageUrl: _news['media'].first['path'],
                            width: 30,
                            height: 50,
                          ),
                        );
                      });
                }).toList()))
      ],
    );
  }
}
