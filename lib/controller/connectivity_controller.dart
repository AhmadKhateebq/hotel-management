import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_api.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_offlne.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_repository.dart';
import 'package:hotel_management/util/const.dart';
// import 'package:restart_app/restart_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConnectivityController extends GetxController {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  RxBool connected = false.obs;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _online = false;
  bool _offline = false;
  late StreamSubscription requestsStreamListener;
  ConnectivityResult get connectedStatus => _connectionStatus;

  StreamSubscription<ConnectivityResult> get subscription =>
      _connectivitySubscription;

  init() async {
    await initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  getConnectivityStream(){

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
    _connectionStatus = result;
    result == ConnectivityResult.none
        ? connected.value = false
        : connected.value = true;

    if (result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      if (_offline) {
        _offline = false;
        _online = true;
        Get.delete<SupabaseAuthController>();
        Get.delete<CustomerRepository>();
        try {
          await Supabase.initialize(
            url: supabaseUrl,
            anonKey: publicAnonKey,
          );
        } catch (error) {
          log(error: error, 'error');
        }
        Get.put(SupabaseAuthController.online(), permanent: true);
        Get.put<CustomerLocal>(CustomerLocal(), permanent: true);
        Get.put<CustomerRepository>(CustomerApi(), permanent: true);
        initUser();
        try{
          requestsStreamListener.resume();
        }catch(e){
          if(kDebugMode){

          }
        }
      }
    }
    if (result == ConnectivityResult.none) {
      if (_online) {
        _online = false;
        _offline = true;
        Get.delete<SupabaseAuthController>();
        Get.delete<CustomerRepository>();
        Get.delete<CustomerLocal>();
        Get.put(SupabaseAuthController.offline(), permanent: true);
        Get.put<CustomerRepository>(CustomerLocal(), permanent: true);
        initUser();
        try{
          requestsStreamListener.pause();
        }catch(e){
          if(kDebugMode){

          }
        }
      }
    }
  }

  initUser() async {
    var authController = Get.find<SupabaseAuthController>();
    var customerApi = Get.find<CustomerRepository>();
    if (_online) {
      await customerApi.getCustomerDetails(authController.currentUser()!.id);
      authController.getUserData();
    } else {
      authController.getUserData();
      Get.find<CustomerRepository>().getCustomerDetails('');
    }
  }

  void streamController(StreamSubscription listener) {
    requestsStreamListener = listener;
  }
  get isOnline => _online;
  get isOffline => _offline;
}
