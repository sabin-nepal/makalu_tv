
import 'package:shared_preferences/shared_preferences.dart';

class UserSharePreferences{
  
  Future<bool> checkIfVote(String id) async{
    final prefs = await SharedPreferences.getInstance();
    final vote = prefs.get(id);
    if (vote==null){
      return false;
    }
    return true;
  }

  Future<void> vote(String id) async{
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

}