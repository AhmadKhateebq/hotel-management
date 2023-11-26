import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/controller/login_controller.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/firebase_options.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_api.dart';
import 'package:hotel_management/mvvm/repository/request/requests_cache.dart';
import 'package:hotel_management/mvvm/repository/request/room_request_repository.dart';
import 'package:hotel_management/mvvm/repository/room/room_cache.dart';
import 'package:hotel_management/mvvm/repository/room/room_repository.dart';
import 'package:hotel_management/util/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreenViewModel {
  RxBool isLoading = true.obs;

  initApp() async {
    //shared pref
    await SharedPrefController.init();

    Get.put(ConnectivityController(), permanent: true);
    Get.put(CustomerApi(), permanent: true);
    //set up connectivity sub
    await Get.find<ConnectivityController>().init();
    bool internet = Get.find<ConnectivityController>().connected.value;
    //try to init firebase for analytics
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //try to init supabase
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
    //start the login process
    final LoginController loginController = Get.put(LoginController());
    Get.put<RoomRequestRepository>(RoomRequestCache(), permanent: true);
    Get.put<RoomRepository>(RoomCache(), permanent: true);
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.setAnalyticsCollectionEnabled(true);
    await analytics.logAppOpen();
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: ["36503A67BE05B5A6A4AC1DC738CAB9FC"]));
    await loginController.init();
  }
}
