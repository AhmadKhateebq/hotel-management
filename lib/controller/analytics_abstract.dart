// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
// import 'package:get/get.dart';
// import 'package:hotel_management/util/const.dart';
// import 'package:hotel_management/util/date_formatter_util.dart';
//
// abstract class AnalyticsServiceAbstract extends GetxController {
//   final _firebaseAnalytics = FirebaseAnalytics.instance;
//   final _eventStandard = BranchEvent.standardEvent(BranchStandardEvent.PURCHASE)
//     //--optional Event data
//     ..transactionID = '12344555'
//     ..alias = 'StandardEventAlias'
//     ..currency = BranchCurrencyType.BRL
//     ..revenue = 1.5
//     ..shipping = 10.2
//     ..tax = 12.3
//     ..coupon = 'test_coupon'
//     ..affiliation = 'test_affiliation'
//     ..eventDescription = 'Event_description'
//     ..searchQuery = 'item 123'
//     ..adType = BranchEventAdType.BANNER
//     ..addCustomData('Custom_Event_Property_Key1', 'Custom_Event_Property_val1')
//     ..addCustomData('Custom_Event_Property_Key2', 'Custom_Event_Property_val2');
//   BranchContentMetaData metadata = BranchContentMetaData();
//   final _eventCustom = BranchEvent.customEvent('Custom_event')
//     ..alias = 'appStart'
//     ..addCustomData('Start_Time', DateFormatter.format(DateTime.now()));
//
//
//   Future<void> init() async {
//     await FlutterBranchSdk.init();
//   }
//
//   List<Function> get _log => [
//     (String name, Map<String, dynamic> parameters) =>
//         FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters),
//     (String name, Map<String, dynamic> parameters) =>
//         FlutterBranchSdk.trackContent(buo: [_buo], branchEvent:  BranchEvent.customEvent(
//           name,
//         )),
//   ];
//
//   log(String name, Map<String, Object> data, {BranchEvent? event}) async {
//     await _firebaseAnalytics.logEvent(name: name, parameters: data);
//     FlutterBranchSdk.trackContent(
//         buo: [_buo],
//         branchEvent: event ??
//             BranchEvent.customEvent(
//               name,
//             ));
//   }
//
//   logPurchase(Map<String, Object> data, {BranchEvent? event}) async {
//     await _firebaseAnalytics.logPurchase(
//         value: double.parse((data['price'] ?? data['value']).toString()),
//         currency: 'USD',
//         parameters: data);
//     FlutterBranchSdk.trackContent(
//       buo: [_buo],
//       branchEvent: event ??
//           BranchEvent.customEvent(
//             'purchase',
//           )
//         ..currency = BranchCurrencyType.USD
//         ..revenue = double.parse((data['price'] ?? data['value']).toString())
//         ..tax = double.parse((data['tax'] ?? 0).toString()),
//     );
//   }
// }
