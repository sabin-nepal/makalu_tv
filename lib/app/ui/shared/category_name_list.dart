import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/category.dart';
import 'package:makalu_tv/app/styles/colors.dart';

class CategoryNameList extends StatefulWidget {
  final Category category;
  final ValueChanged<bool> onSelected;
  final List selectedItems;
  CategoryNameList({this.category, this.onSelected, this.selectedItems});

  @override
  _CategoryNameListState createState() => _CategoryNameListState();
}

class _CategoryNameListState extends State<CategoryNameList> {
  bool isSelected = false;

  @override
  void initState(){
    super.initState();
    _setSelectedItems();
  }

  _setSelectedItems(){
    if(widget.selectedItems.contains(widget.category.id)){
      isSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Text(widget.category.title ?? ''),
        Spacer(),
        Container(
          child: IconButton(
              icon: Icon(
                isSelected ? Icons.circle : Icons.circle_outlined,
                color: AppColors.activeColor,
              ),
              onPressed: () {
                setState(() {
                  isSelected = !isSelected;
                  widget.onSelected(isSelected);
                });
              }),
        ),
      ]),
    );
  }
}
