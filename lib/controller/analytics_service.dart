// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
// import 'package:get/get.dart';
// import 'package:hotel_management/controller/analytics_abstract.dart';
// import 'package:hotel_management/interface/room.dart';
// import 'package:hotel_management/model/user_model.dart';
// import 'package:hotel_management/util/const.dart';
// import 'package:hotel_management/util/date_formatter_util.dart';
//
// class AnalyticsService extends AnalyticsServiceAbstract {
//
//   reserveRoom(Room room) async {
//     final data = {
//       'transaction_id': 'T)ID',
//       'value': '${room.price}',
//       'currency': 'USD',
//       'tax': 0,
//       'shipping': 0,
//       'coupon': '',
//       'item_id': room.roomId,
//       'item_name': room.roomId,
//       'item_brand': 'Room',
//       'item_category': room.floorText,
//       'quantity': 1,
//     };
//     var event = BranchEvent.standardEvent(BranchStandardEvent.PURCHASE)
//       ..currency = BranchCurrencyType.USD
//       ..revenue = room.price
//       ..tax = 10
//       ..transactionID =
//           '${room.roomId}_${Get.find<UserModel>().customerId}_${DateFormatter.formatWithTime(DateTime.now())}';
//     logPurchase(data, event: event);
//   }
//   logLogIn(){
//     final data = {
//       'user_id' : Get.find<UserModel>().customerId,
//       'time' : DateFormatter.formatWithTime(DateTime.now()),
//     };
//     log('logged_in', data);
//   }
//   logLogOut(){
//     final data = {
//     'user_id' : Get.find<UserModel>().customerId,
//     'time' : DateFormatter.formatWithTime(DateTime.now()),
//   };
//     log('logged_out', data);
//     }
//
//
// }
