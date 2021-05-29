import 'package:flutter/material.dart';
import 'package:makalu_tv/app/styles/colors.dart';

class PrimaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:200.0,
      padding: EdgeInsets.symmetric(horizontal:10.0),
      decoration: BoxDecoration(
        border: Border.all(width:1.0),
        borderRadius:BorderRadius.circular(15.0)
      ),
      child: Column(
        children:[
          Row(children: [
            Expanded(child: Hero(
              tag:'hello',
              child: Container(
                child: Image.network(
                  'https://www.onlinekhabar.com/wp-content/uploads/2021/05/Purva-Sabhamukh.jpg',
                   fit:BoxFit.fitHeight
                   ),
              )
              ))
          ],)
        ]
      ),
    );
  }
}