import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';
import 'package:makalu_tv/app/models/category.dart';
import 'package:makalu_tv/app/services/category_service.dart';
import 'package:makalu_tv/app/styles/colors.dart';
import 'package:makalu_tv/app/styles/sizes.dart';
import 'package:makalu_tv/app/styles/styles.dart';
import 'package:makalu_tv/app/ui/shared/category_name_list.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notification = false;
  UserSharePreferences _userSharePreferences = UserSharePreferences();
  List _selectedCategories;
  List _oldSelectedCategories;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
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

  void _sendFeedback() async {
    String subject;
    String bodyText;
    try {
      if (Platform.isAndroid) {
        subject = '${DateTime.now()} Feedback of Makalu Tv Android App';
        AndroidDeviceInfo _androidDeviceInfo =
            await deviceInfoPlugin.androidInfo;
        bodyText = 'Device: ${_androidDeviceInfo.device} \n';
        bodyText += 'Android Id: ${_androidDeviceInfo.androidId} \n ';
        bodyText += 'Hardware: ${_androidDeviceInfo.hardware} \n ';
        bodyText += 'Brand: ${_androidDeviceInfo.brand} \n ';
        bodyText += 'Model: ${_androidDeviceInfo.model} \n ';
        bodyText += 'Device Width: ${MediaQuery.of(context).size.width} \n ';
        bodyText += 'Device Height: ${MediaQuery.of(context).size.height} \n ';
        bodyText +=
            "--Please don't delete anything above this line to help us serve you better--";
      }
      if (Platform.isIOS) {
        subject = '${DateTime.now()} Feedback of Makalu Tv Ios App';
        IosDeviceInfo _iosDeviceInfo = await deviceInfoPlugin.iosInfo;
        bodyText = 'Device Name: ${_iosDeviceInfo.name} \n';
        bodyText += 'System Name: ${_iosDeviceInfo.systemName} \n ';
        bodyText += 'System Version: ${_iosDeviceInfo.systemVersion} \n ';
        bodyText += 'Model: ${_iosDeviceInfo.model} \n ';
        bodyText += 'Width: ${MediaQuery.of(context).size.width} \n ';
        bodyText += 'Height: ${MediaQuery.of(context).size.height} \n ';
        bodyText +=
            "--Please don't delete anything above this line to help us serve you better--";
      }
    } on PlatformException {
      print('Error on getting device Information');
    }

    if (!mounted) return;
    String uri =
        'mailto:test@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(bodyText)}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      print("No email client found");
    }
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
              title: Text(
                "Notification",
                style: boldText,
              ),
              value: _notification,
              onChanged: _onChanged,
            ),
            _notification ? _categoryList() : Container(),
            ListTile(
              onTap: _sendFeedback,
              title: Text(
                "FeedBack",
                style: boldText,
              ),
              subtitle: Text(
                "We appreciate your feedback",
                style: descriptionText,
              ),
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
        return Center(
            child: Text("Please,Check Your Internet Connection..",
                style: boldText));
      },
    );
  }
}
