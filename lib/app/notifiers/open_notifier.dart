import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';

class FirstOpenNotifier extends ChangeNotifier {
  UserSharePreferences _userSharePreferences = UserSharePreferences();
  bool _firstOpen;
  bool get isOpened => _firstOpen;
  
  FirstOpenNotifier(){
    alreadyOpened();
  }
  
  alreadyOpened() async {
    _firstOpen = await _userSharePreferences.isOpened();
    notifyListeners();
  }
  setOpened(bool value) async {
    await _userSharePreferences.firstOpen(value);
    _firstOpen = true;
    notifyListeners(); 
  }
}
