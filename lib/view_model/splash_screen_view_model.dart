import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/controller/login_controller.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/firebase_options.dart';
import 'package:hotel_management/model/request_model.dart';
import 'package:hotel_management/model/room_model.dart';
import 'package:hotel_management/model/user_model.dart';
import 'package:hotel_management/repository/customer/customer_api.dart';
import 'package:hotel_management/repository/room_requests_repository_impl.dart';
import 'package:hotel_management/repository/request/room_request_repository.dart';
import 'package:hotel_management/repository/room_repository_impl.dart';
import 'package:hotel_management/repository/room/room_repository.dart';
import 'package:hotel_management/util/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreenViewModel {
  initApp() async {
    //shared pref
    await SharedPrefController.init();
    Get.put(ConnectivityController(), permanent: true);
    Get.put(CustomerApi(), permanent: true);
    try{
      await Get.find<CustomerApi>().init();
    }catch(e){
      if(kDebugMode){
        print(e);
      }
    }
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
    Get.put<RoomRepository>(RoomRepositoryImpl(), permanent: true);
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.setAnalyticsCollectionEnabled(true);
    await analytics.logAppOpen();
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: ["36503A67BE05B5A6A4AC1DC738CAB9FC"]));
    Get.put(RoomModel());
    Get.put(RequestModel());
    Get.put(UserModel());
    await loginController.init();
  }
}
