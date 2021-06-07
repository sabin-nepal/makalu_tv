import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/news/insight.dart';
import 'package:makalu_tv/app/services/news/insight_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:stacked_page_view/stacked_page_view.dart';

class InsightScreen extends StatelessWidget {
  final int position;
  InsightScreen({this.position});
  @override
  Widget build(BuildContext context) {
    final PageController pageController =
        PageController(initialPage: position ?? 0);
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
              decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
          centerTitle: true,
          title: Text(
            'Insight',
          ),
        ),
        body: FutureBuilder(
            future: InsightService.getInsight(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Center(child: Text("Somethings went wrong.."),);
              }
              if (snapshot.hasData)
                return PageView.builder(
                  controller: pageController,
                  pageSnapping: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    Insight insight = snapshot.data[i];
                    return StackPageView(
                        index: i,
                        controller: pageController,
                        child: Container());
                  },
                );
              return Center(child: CircularProgressIndicator());
            }));
  }
}
