import 'package:flutter/material.dart';
import 'package:makalu_tv/app/services/adv_service.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/ui/shared/news_page_view.dart';

class NewsScreen extends StatefulWidget {
  final String title;
  final String type;
  NewsScreen({this.title, this.type});
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool order = false;
  var limit;
  var offset = 0;
  int position = 0;
  List _adv = [];
  @override
  void initState() {
    super.initState();
    _setStatus();
    _fetchAdv();
  }

  void _setStatus() {
    if (widget.type == "trending") {
      limit = 10;
    }
    if (widget.type == "top") {
      limit = 15;
    }
    if (widget.type == "news") {
      order = true;
      limit = 1;
    }
    if (widget.type == "feed") {
      order = true;
      limit = 100;
    }
  }

  _fetchAdv() async {
    var adv = await AdvService.getAdv();
    adv.forEach((element) {
      _adv.add(element);
    });
  }

  Future<void> _refreshNews(BuildContext context) async {
    var _news = widget.type == "unread"
        ? await NewsService.getDailyNews()
        : await NewsService.getNewsType(type: "", limit: limit, offset: offset, order: order);
    return _news;
  }

  _mergeList(List news) {
    List _news = List.from(news);
    if (_adv.isNotEmpty) {
      var j = 0;
      for (var i = 0; i < _news.length; i++) {
        if (i % 2 == 1 && _adv.length > j) {
          if (_adv[j].type == 'full') _news.insert(i, _adv[j]);
          j++;
        }
      }
    }
    return _news;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
        centerTitle: true,
        title: Text(
          widget.title,
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(
              Icons.refresh,
              color: AppColors.bgColor,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshNews(context),
        child: FutureBuilder(
            future: widget.type == "unread"
                ? NewsService.getDailyNews()
                : NewsService.getNewsType(
                    type: "", limit: limit, offset: offset, order: order),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                List news = _mergeList(snapshot.data);
                return NewsPageView(
                  news: news,
                  type:widget.type,
                  showRemaining: true,
                );
              }
              return Container();
            }),
      ),
    );
  }
}
