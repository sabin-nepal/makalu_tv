import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/news/insight.dart';
import 'package:makalu_tv/app/services/news/insight_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/ui/shared/custom_stack_page_view.dart';
import 'package:makalu_tv/app/ui/shared/insight_item_view.dart';

class InsightScreen extends StatefulWidget {
  final int position;
  InsightScreen({this.position});

  @override
  _InsightScreenState createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: widget.position, keepPage: true, viewportFraction: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              if (snapshot.hasError) {
                return Center(
                  child: Text("Somethings went wrong.."),
                );
              }
              if (snapshot.hasData)
                return PageView.builder(
                  controller: _pageController,
                  pageSnapping: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    Insight insight = snapshot.data[i];
                    return CustomStackPageView(
                        index: i,
                        initial: widget.position,
                        controller: _pageController,
                        child: InsightItemView(
                          insight: insight,
                        ));
                  },
                );
              return Center(child: CircularProgressIndicator());
            }));
  }
}
