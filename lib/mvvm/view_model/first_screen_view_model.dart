import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/firebase_options.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_api.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_offlne.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_repository.dart';
import 'package:hotel_management/mvvm/repository/request/requests_cache.dart';
import 'package:hotel_management/mvvm/repository/request/room_request_repository.dart';
import 'package:hotel_management/mvvm/repository/room/room_cache.dart';
import 'package:hotel_management/mvvm/repository/room/room_repository.dart';
import 'package:hotel_management/util/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirstScreenViewModel {
  late SupabaseAuthController _authController;
  late CustomerRepository _customerApi;
  final _pref = SharedPrefController.reference;
  RxBool isLoading = true.obs;

  init() async {
    try {
      _authController = Get.find();
      _customerApi = Get.find();
      isLoading.value = true;
      if(_pref.containsKey('role')){
        if (_authController.currentUser() != null ) {
          await _customerApi
              .getCustomerDetails(_authController.currentUser()!.id);
          _authController.getUserData();
        } else {
          _authController.getUserData();
          Get.find<CustomerRepository>().getCustomerDetails('');
          isLoading.value = false;
        }
      }else{
        Get.offNamed('/login');
      }

    } catch (e) {
      Get.find<SupabaseAuthController>().signOut();
    }
  }

  initControllers() async {
    bool internet = Get.find<ConnectivityController>().connected.value;
    // Get.put(FirebaseAnalyticsController());
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (internet) {
      try {
        await Supabase.initialize(
          url: supabaseUrl,
          anonKey: publicAnonKey,
        );
      } catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
      try {
        Get.put(SupabaseAuthController.online(), permanent: true);
        Get.put<CustomerLocal>(CustomerLocal(), permanent: true);
        Get.put<CustomerRepository>(CustomerApi(), permanent: true);
      } catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } else {
      Get.put(SupabaseAuthController.offline(), permanent: true);
      Get.put<CustomerRepository>(CustomerLocal(), permanent: true);
    }
    Get.put<RoomRequestRepository>(RoomRequestCache(), permanent: true);
    Get.put<RoomRepository>(RoomCache(), permanent: true);
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.setAnalyticsCollectionEnabled(true);
    await analytics.logAppOpen();
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: ["36503A67BE05B5A6A4AC1DC738CAB9FC"]));
    init();
  }
}
