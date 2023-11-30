import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefController{
  static late final SharedPreferences _prefs;
  static bool _isInit = false;
  static init() async {
    if(!_isInit) {
      _prefs = await SharedPreferences.getInstance();
      _isInit = true;
    }
  }
  static SharedPreferences get reference => _prefs;
}