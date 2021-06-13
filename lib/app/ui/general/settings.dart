import 'package:flutter/material.dart';
import 'package:makalu_tv/app/models/category.dart';
import 'package:makalu_tv/app/services/category_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:makalu_tv/app/ui/shared/category_grid_item_list.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notification = false;
  _onChanged(bool value) {
    _notification = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
        centerTitle: true,
        title: Text(
          'Settings',
        ),
        actions: [
          if(_notification)
            Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
              title: Text("Notification"),
              value: _notification,
              onChanged: _onChanged,
            ),
            _notification ? _categoryList() : Container(),
            ListTile(
              title: Text("FeedBack"),
              subtitle: Text("We appreciate your feedback"),
            )
          ],
        ),
      ),
    );
  }

  Widget _categoryList() {
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
                return Container();
              });
        }
        return Center(child: Text("Please,Check Your Internet Connection.."));
      },
    );
  }
}
