import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/models/category.dart';
import 'package:makalu_tv/app/services/category_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/ui/shared/category_name_list.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notification = false;
  UserSharePreferences _userSharePreferences = UserSharePreferences();
  List _selectedCategories;
  List _oldSelectedCategories;
  @override
  void initState() {
    super.initState();
    _isNotification();
  }

  _isNotification() async {
    _notification = await _userSharePreferences.isNotification();
    _selectedCategories =
        await _userSharePreferences.getCategoryForNotification() ?? [];
    _oldSelectedCategories = _selectedCategories;
    setState(() {});
  }

  _onChanged(bool value) async {
    await _userSharePreferences.setNotification(value);
    setState(() {
      _notification = value;
    });
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
          if (_notification)
            InkWell(
              onTap: () => _subscribeForNotification(),
              child: Container(
                margin: EdgeInsets.only(right: AppSizes.padding),
                child: Center(child: Text("Save")),
              ),
            ),
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
          return Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Category category = snapshot.data[index];
                    return CategoryNameList(
                      category: category,
                      selectedItems: _selectedCategories,
                      onSelected: (value) {
                        if (value) {
                          _selectedCategories.add(category.id);
                        } else {
                          _selectedCategories.remove(category.id);
                        }
                      },
                    );
                  }),
              ElevatedButton(
                child: Text("Save"),
                onPressed: () {
                  _subscribeForNotification();
                },
              )
            ],
          );
        }
        return Center(child: Text("Please,Check Your Internet Connection.."));
      },
    );
  }

  _subscribeForNotification() async {
    if (_selectedCategories.isEmpty) return _showToast(context);
    for (var item in _selectedCategories) {
      if (!_oldSelectedCategories.contains(item)) {
        await FirebaseMessaging.instance.unsubscribeFromTopic(item);
      } else {
        await FirebaseMessaging.instance.subscribeToTopic(item);
      }
      await _userSharePreferences.saveCategoryForNotification(item);
    }
    setState(() {});
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryColor,
        duration: Duration(milliseconds: 1000),
        content: Text("Select Items"),
      ),
    );
  }
}
