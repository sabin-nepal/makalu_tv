import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/category.dart';
import 'package:makalu_tv/app/styles/colors.dart';

class CategoryItem extends StatefulWidget {
  final Category category;
  final ValueChanged<bool> onSelected;

  CategoryItem({this.category, this.onSelected});

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.onSelected(isSelected);
        });
      },
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              widget.category.title ?? '',
              style: TextStyle(color: AppColors.bgColor, fontSize: 20),
            ),
            decoration: BoxDecoration(
                color: AppColors.accentColor,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                    image: NetworkImage(widget.category.media['path'])),
                borderRadius: BorderRadius.circular(15)),
          ),
          if (isSelected)
            Positioned(
              right: 5.0,
              bottom: 0.0,
              child: Icon(
                Icons.remove_circle,
                color: AppColors.activeColor,
              ),
            ),
        ],
      ),
    );
  }
}
