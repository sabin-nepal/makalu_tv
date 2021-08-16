import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/models/category.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/styles.dart';

class FilterList extends StatefulWidget {
  final Category category;
  FilterList({this.category});

  @override
  _FilterListState createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  int checkFilter = 3;
  @override
  void initState() {
    super.initState();
    _setSelectedItems();
  }

  _setSelectedItems() async {
    checkFilter = await UserSharePreferences().getFilter(widget.category.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              width: 200,
              child: AutoSizeText(
                widget.category.title,
                maxLines: 2,
                style: titleText,
              ),
            ),
            IconButton(
                onPressed: () async {
                  await UserSharePreferences()
                      .saveFilter(widget.category.id, 1);
                  checkFilter = 1;
                  setState(() {});
                },
                icon: Icon(
                    checkFilter == 1 ? Icons.circle : Icons.circle_outlined,
                    color: AppColors.allNewsColor)),
            IconButton(
                onPressed: () async {
                  await UserSharePreferences()
                      .saveFilter(widget.category.id, 2);
                  checkFilter = 2;
                  setState(() {});
                },
                icon: Icon(
                    checkFilter == 2 ? Icons.circle : Icons.circle_outlined,
                    color: AppColors.majorNewsColor)),
            IconButton(
                onPressed: () async {
                  await UserSharePreferences()
                      .saveFilter(widget.category.id, 3);
                  checkFilter = 3;
                  setState(() {});
                },
                icon: Icon(
                    checkFilter == 3 ? Icons.circle : Icons.circle_outlined,
                    color: AppColors.noNewsColor)),
          ],
        ),
      ),
    );
  }
}
