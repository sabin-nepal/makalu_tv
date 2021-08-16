import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/category.dart';
import 'package:makalu_tv/app/services/category_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:makalu_tv/app/ui/shared/filter_list.dart';

class CategoryFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.all(AppSizes.paddingSm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.accentColor,
                      )),
                  Text(
                    "Filter for news here you can",
                    style: boldText,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.circle_outlined, color: AppColors.allNewsColor),
                  Text("All News", style: titleText),
                  Icon(Icons.circle_outlined, color: AppColors.majorNewsColor),
                  Text("Major News", style: titleText),
                  Icon(Icons.circle_outlined, color: AppColors.noNewsColor),
                  Text("No News", style: titleText),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
              _buildCategoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return FutureBuilder(
        future: CategoryService.getCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Category category = snapshot.data[index];
                  return FilterList(category: category);
                });
          }
          return Center(
              child: Text("Please,Check Your Internet Connection..",
                  style: boldText));
        });
  }
}
