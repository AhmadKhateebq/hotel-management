import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotel_management/util/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  RxBool connected = false.obs;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _online = false;
  bool _offline = false;
  late StreamSubscription requestsStreamListener;
  StreamSubscription<ConnectivityResult> get subscription =>
      _connectivitySubscription;

  init() async {
    await initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      result == ConnectivityResult.none
          ? connected.value = false
          : connected.value = true;
      _online = connected.value;
      _offline = !_online;
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    result == ConnectivityResult.none
        ? connected.value = false
        : connected.value = true;

    if (result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      connected.value = true;
      if (_offline) {
        _offline = false;
        _online = true;
        try {
          await Supabase.initialize(
            url: supabaseUrl,
            anonKey: publicAnonKey,
          );
        } catch (error) {
          log(error: error, 'error');
        }
        try{
          requestsStreamListener.resume();
        }catch(e){
          if(kDebugMode){

          }
        }
      }
    }
    if (result == ConnectivityResult.none) {
      connected.value = false;
      if (_online) {
        _online = false;
        _offline = true;
        try{
          requestsStreamListener.pause();
        }catch(e){
          if(kDebugMode){

          }
        }
      }
    }
  }
}
