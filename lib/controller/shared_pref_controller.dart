import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hotel_management/util/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SharedPrefController extends GetxController {
  late final SharedPreferences _prefs;
  bool _isInit = false;

  init() async {
    if (!_isInit) {
      _prefs = await SharedPreferences.getInstance();
      _isInit = true;
    }
  }

  SharedPreferences get reference => _prefs;
}

class SupabaseController extends GetxController {
  late final SupabaseClient _supabase;
  bool _isInit = false;

  init() async {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: publicAnonKey,
      );
      _isInit = true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      _supabase = Supabase.instance.client;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  SupabaseClient get client {
    if (_isInit) {
      return _supabase;
    } else {
      try {
        Supabase.initialize(url: supabaseUrl, anonKey: publicAnonKey);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }

      return _supabase;
    }
  }
}
