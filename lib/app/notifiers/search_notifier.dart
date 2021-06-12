import 'package:flutter/material.dart';
import 'package:makalu_tv/app/helpers/user_share_preferences.dart';

class SearchNotifier extends ChangeNotifier {
  UserSharePreferences _userSharePreferences = UserSharePreferences();
  List suggestions;
  List get getSuggestions => suggestions;
  fetchSuggestions(String query) async{
    suggestions = await _userSharePreferences.getRecentSearchesLike(query);
    notifyListeners();
  }
}
