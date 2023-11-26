import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/controller/login_controller.dart';
import 'package:hotel_management/firebase_options.dart';
import 'package:hotel_management/mvvm/repository/request/requests_cache.dart';
import 'package:hotel_management/mvvm/repository/request/room_request_repository.dart';
import 'package:hotel_management/mvvm/repository/room/room_cache.dart';
import 'package:hotel_management/mvvm/repository/room/room_repository.dart';
import 'package:hotel_management/util/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreenViewModel {
  RxBool isLoading = true.obs;
  final LoginController loginController = Get.put(LoginController());
  init() async {
    await loginController.init();
    // try {
    //   _authController = Get.find();
    //   isLoading.value = true;
    //   if(_pref.containsKey('role')){
    //     if (_authController.currentUser() != null ) {
    //       var role = await _customerApi
    //           .getCustomerDetails(_authController.currentUser()!.id);
    //       if (role == ROLE.customer) {
    //         Get.offAllNamed('/home');
    //       } else {
    //         Get.offAllNamed('/recep_home');
    //       }
    //     } else {
    //       isLoading.value = false;
    //       Get.find<SupabaseAuthController>().signOut();
    //       Get.off(()=>const LoginScreen());
    //     }
    //   }else{
    //     Get.off(()=>const LoginScreen());
    //   }
    // }
    // catch (e) {
    //   Get.find<SupabaseAuthController>().signOut();
    // }
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
    }
    Get.put(LoginController());
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
