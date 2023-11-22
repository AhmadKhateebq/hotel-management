import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefController{
  static late final SharedPreferences _prefs;
  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  static get reference => _prefs;
}