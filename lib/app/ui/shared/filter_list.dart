import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(widget.category.title,style: titleText,),
        IconButton(onPressed: null, icon: Icon(Icons.circle,color: AppColors.allNewsColor)),
        IconButton(onPressed: null, icon: Icon(Icons.circle,color: AppColors.noNewsColor)),
      ],
    );
  }
}