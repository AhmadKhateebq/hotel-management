import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hotel_management/analytics/analytics_service.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/controller/login_controller.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/firebase_options.dart';
import 'package:hotel_management/model/request/all_request_model.dart';
import 'package:hotel_management/model/request/my_request_model.dart';
import 'package:hotel_management/model/room/room_model.dart';
import 'package:hotel_management/model/user_model.dart';
import 'package:hotel_management/repository/customer/customer_api.dart';
import 'package:hotel_management/repository/request/room_request_repository.dart';
import 'package:hotel_management/repository/room/room_repository.dart';
import 'package:hotel_management/repository/room_repository_impl.dart';
import 'package:hotel_management/repository/room_requests_repository_impl.dart';
import 'package:hotel_management/util/file_output.dart';
import 'package:hotel_management/util/util_classes.dart';

class SplashScreenViewModel {
  initApp() async {
    CustomLogger.logger.i('app init', time: DateTime.now());
    //shared pref
    await Get.put(SharedPrefController(),permanent: true).init();
    Get.put(ConnectivityController(), permanent: true);
    Get.put(SupabaseController(), permanent: true);
    // Get.find<AnalyticsService>().trackContentTest();
    try {
      await Get.find<SupabaseController>().init();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    Get.put(CustomerApi(), permanent: true);
    await Get.find<ConnectivityController>().init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final LoginController loginController =
        Get.put(LoginController(), permanent: true);
    Get.put<RoomRequestRepository>(RoomRequestRepositoryImpl(),
        permanent: true);
    Get.put<RoomRepository>(RoomRepositoryImpl(), permanent: true);
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.setAnalyticsCollectionEnabled(true);
    await analytics.logAppOpen();
    if (!kIsWeb) {
      await MobileAds.instance.initialize();
      await MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
          testDeviceIds: [
            "36503A67BE05B5A6A4AC1DC738CAB9FC",
            "4C64E6FF677DCC8FDFEBE1C4DAF6F1AA"
          ]));
    }
    Get.put(RoomModel(), permanent: true);
    Get.put(UserModel(), permanent: true);
    Get.put(AnalyticsService(), permanent: true);
    await loginController.init();
    setUpNav();
  }

  setUpNav() async {
    try {
      await FlutterBranchSdk.init();
      // FlutterBranchSdk.validateSDKIntegration();
    } catch (e, _) {
      CustomLogger.logger.e('init error', error: e);
    }
    // FlutterBranchSdk.listSession().listen(onData);
    var data = await FlutterBranchSdk.getLatestReferringParams();
    onData(data);
  }

  void onData(Map<dynamic, dynamic> data) {
    log(data.toString());
    if (data.containsKey("+clicked_branch_link") &&
        data["+clicked_branch_link"] == true) {
      //is from branch , set analytics
      String path = '${data['\$deeplink_path']}';
      String query = Uri.parse(data['~referring_link']).query;
      navigate(path: '$path?$query', arguments: data);
      //Link clicked. Add logic to get link data and route user to correct screen
    } else if (data.containsKey('+non_branch_link')) {
      String value = data['+non_branch_link'];
      Get.arguments['deep_link_data'] = data;
      var uri = Uri.parse(value);
      String path = uri.path;
      log('deep link');
      navigate(path: '$path?${uri.query}', arguments: data);
    } else {
      log('non deep link');
      navigate();
    }
  }

  void navigate({String? path, dynamic arguments}) {
    Get.find<UserModel>().getDetails();
    final role = RoleUtil.fromString(Get.find<UserModel>().role);
    Get.put<MyRequestModel>(MyRequestModel(), permanent: true);
    if (role != ROLE.customer) {
      Get.put<AllRequestModel>(AllRequestModel(), permanent: true);
    }
    if (path == null) {
      _navToHome(role);
    } else {
      var name = path.split('/')[1];
      name = name.split('?')[0];
      if (!deepLinks.contains(name)) {
        Get.snackbar('Not Found', 'Sorry, We Cant Find Your Screen !');
        _navToHome(role);
      } else {
        Get.offNamed('/deepLink$path', arguments: arguments);
      }
    }
  }

  _navToHome(ROLE role) {
    if (role == ROLE.customer) {
      Get.offNamed('/home');
    } else {
      Get.offNamed('/recep_home');
    }
  }
}

const deepLinks = ['/room', 'room'];
