import 'dart:convert';

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
    if (allSearches != null)
      return allSearches.where((search) => search.startsWith(query)).toList();
    return [];
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

  Future<List<String>> getCategoryForNotification() async {
    final pref = await SharedPreferences.getInstance();
    final allCategories = pref.getStringList("categoryForNotification");
    return allCategories;
  }

  Future<void> saveCategoryForNotification(String category) async {
    final pref = await SharedPreferences.getInstance();
    pref.remove('categoryForNotification');
    Set<String> allCategory =
        pref.getStringList("categoryForNotification")?.toSet() ?? {};
    allCategory = {category, ...allCategory};
    pref.setStringList("categoryForNotification", allCategory.toList());
  }

  Future setNotification(bool value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('isNotification', value);
  }

  Future<bool> isNotification() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('isNotification') ?? false;
  }

  //for bookmark

  Future saveBookMark(String id, Map value) async {
    final pref = await SharedPreferences.getInstance();
    String encoded = json.encode(value);
    Set<String> allNews = pref.getStringList("bookmark")?.toSet() ?? {};
    allNews = {encoded, ...allNews};
    pref.setBool('bookmarkId$id', true);
    pref.setStringList('bookmark', allNews.toList());
  }

  Future getBookMark() async {
    final pref = await SharedPreferences.getInstance();
    final allNews = pref.getStringList('bookmark');
    return allNews;
  }

  Future<bool> hasBookMark(String id) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('bookmarkId$id');
  }

  Future removeBookMark(String id, Map value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('bookmarkId$id', false);
    final allNews = pref.getStringList("bookmark");
    String encoded = json.encode(value);
    allNews.remove(encoded);
    pref.setStringList("bookmark", allNews.toList());
  }

  //display news by category filter
  Future saveFilter(String id, int value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt('filter$id', value);
    Set<String> allCategory = pref.getStringList("filterCat")?.toSet() ?? {};
    allCategory = {id, ...allCategory};
    pref.setStringList("filterCat", allCategory.toList());
  }

  Future<int> getFilter(String id) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getInt('filter$id');
  }

  Future<List<String>> getFilterCategory() async {
    final pref = await SharedPreferences.getInstance();
    final allCategories = pref.getStringList("filterCat");
    return allCategories;
  }

  Future deleteFilterCategory(String query) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("filterCat");
    allSearches.remove(query);
    pref.setStringList("filterCat", allSearches.toList());
  }
}
