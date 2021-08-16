import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/models/category.dart';
import 'package:makalu_tv/app/notifiers/open_notifier.dart';
import 'package:makalu_tv/app/services/category_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/ui/shared/category_grid_item_list.dart';

class FirstOpen extends StatelessWidget {
  final FirstOpenNotifier notifier;
  FirstOpen({this.notifier});
  @override
  Widget build(BuildContext context) {
    List _selectedCategories = [];
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.primaryGradient)),
        centerTitle: true,
        title: Text(
          'Choose Category',
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: AppSizes.padding),
        child: Column(
          children: [
            Text(
                "Choose the category to get the notification. You can later edit this from settings."),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: CategoryService.getCategory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  if (snapshot.hasData) {
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Category category = snapshot.data[index];
                          _saveFilterCat(category.id);
                          return CategoryGridItem(
                            category: category,
                            onSelected: (value) {
                              if (value) {
                                _selectedCategories.add(category.id);
                              } else {
                                _selectedCategories.remove(category.id);
                              }
                            },
                          );
                        });
                  }
                  return Center(
                      child: Text("Please,Check Your Internet Connection.."));
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                child: Text("Save"),
                onPressed: () {
                  _subscribeForNotification(context, _selectedCategories);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _subscribeForNotification(BuildContext context, List category) async {
    if (category.isEmpty) return _showToast(context);
    UserSharePreferences _userSharePreference = UserSharePreferences();
    for (var item in category) {
      await FirebaseMessaging.instance.subscribeToTopic(item);
      await _userSharePreference.saveCategoryForNotification(item);
    }
    await _userSharePreference.setNotification(true);
    notifier.setOpened(true);
  }

  _saveFilterCat(var id) async {
    await UserSharePreferences().saveFilter(id, 2);
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
