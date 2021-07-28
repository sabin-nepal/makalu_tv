import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/ui/shared/news_page_item.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CategoryNewsDetails extends StatelessWidget {
  final String id;
  final Map news;
  CategoryNewsDetails({this.news, this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
              decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
          centerTitle: true,
          title: Text("News Detail")),
      body: news["url"].isNotEmpty
          ? Builder(builder: (BuildContext context) {
              return WebView(
                initialUrl: news["url"],
                javascriptMode: JavascriptMode.unrestricted,
              );
            })
          : SingleChildScrollView(
              child: NewsPageItem(
                catid: id,
                newsId: news['id'],
                title: news['title'],
                content: news['content'],
                media: news['media'],
                isFullContent: true,
              ),
            ),
    );
  }
}
