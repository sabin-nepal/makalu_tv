
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

}