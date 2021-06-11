import 'package:shared_preferences/shared_preferences.dart';

class UserSharePreferences {
  Future<bool> checkIfVote(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final vote = prefs.get(id);
    if (vote == null) {
      return false;
    }
    return true;
  }

  Future<void> vote(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(id, true);
  }

  Future<List<String>> getRecentSearchesLike(String query) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("recentSearches");
    return allSearches.where((search) => search.startsWith(query)).toList();
  }

  Future<void> saveToRecentSearches(String searchText) async {
    if (searchText == null) return;
    final pref = await SharedPreferences.getInstance();
    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }

  Future deleteRecentSearches(String query) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("recentSearches");
    allSearches.remove(query);
    pref.setStringList("recentSearches", allSearches.toList());
  }

  //first time using app

  Future<void> firstOpen(bool value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('firstOpen', value);
  }

  Future<bool> isOpened() async {
    final pref = await SharedPreferences.getInstance();
    var data = pref.getBool('firstOpen');
    if (data == null) return false;
    return data;
  }

  Future<void> saveCategoryForNotification(String category) async {
    final pref = await SharedPreferences.getInstance();
    Set<String> allCategory =
        pref.getStringList("recentSearches")?.toSet() ?? {};
    allCategory = {category, ...allCategory};
    pref.setStringList("recentSearches", allCategory.toList());
  }
}
