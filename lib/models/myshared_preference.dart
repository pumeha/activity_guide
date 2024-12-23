import 'package:shared_preferences/shared_preferences.dart';

class MysharedPreference {

  Future<String?> getPreferences(String key) async{
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key);

  }

  Future<void> setPreferences(String key, String value) async{
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

}