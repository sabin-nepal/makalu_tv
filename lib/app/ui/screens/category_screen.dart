import 'package:flutter/material.dart';
import 'package:makalu_tv/app/core/constant.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:makalu_tv/app/ui/shared/category_listing.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List _tabPages = [
    'Populars',
    'Latest',
    'Trendings',
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3, initialIndex: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
        centerTitle: true,
        title: Text(
          Constant.categoriesTabKey.toUpperCase(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.activeColor,
          tabs: _tabPages.map<Widget>((e) {
            return Container(
                padding: const EdgeInsets.all(AppSizes.padding),
                child: Text(
                  e,
                  style: boldText,
                ));
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _popularPost(),
          _latestPost(),
          _trendingPost(),
        ],
      ),
    );
  }
  Widget _popularPost(){
    return CategoryListing();
  }
  Widget _latestPost(){
    return CategoryListing();
  }
  Widget _trendingPost(){
    return CategoryListing();
  }
}
