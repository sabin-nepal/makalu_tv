import 'package:flutter/material.dart';
import 'package:makalu_tv/app/services/news/news_service.dart';
import 'package:makalu_tv/app/ui/shared/news_page_view.dart';

class PagePagination extends StatefulWidget {
  final List news;
  final String id;
  final String type;
  final int limit;
  const PagePagination({this.news, this.id, this.type, this.limit});

  @override
  _PagePaginationState createState() => _PagePaginationState();
}

class _PagePaginationState extends State<PagePagination> {
  int currentPage = 1;
  @override
  Widget build(BuildContext context) {
    return NewsPageView(
      news: widget.news,
      showRemaining: true,
      pagination: true,
      paginateQuery: () {
        setState(() {
          _paginateQuery();
        });
      },
    );
  }

  _paginateQuery() {
    if (widget.type == 'category') {
      NewsService.getCategoryNews(
              id: widget.id, limit: widget.limit, page: currentPage)
          .then((value) {
        currentPage++;
        widget.news.addAll(value);
      });
    }
    if (widget.type == 'news') {
      NewsService.getNewsType(
              limit: widget.limit, offset: currentPage, order: true)
          .then((value) {
        currentPage++;
        widget.news.addAll(value);
      });
    }
  }
}
