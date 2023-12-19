import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:hotel_management/analytics/analytics_abstract.dart';
import 'package:hotel_management/model/user_model.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/date_formatter_util.dart';

class BranchAnalyticsImpl extends HotelAnalytics {
  // BranchAnalyticsImpl({required super.eventStream, required super.roomStream});

  BranchUniversalObject get _buo => BranchUniversalObject(
      canonicalIdentifier: 'flutter/branch',
      canonicalUrl: 'https://flutter.dev',
      title: 'Flutter Branch Plugin',
      imageUrl: noImage,
      contentDescription: 'Flutter Branch Description',
      contentMetadata: BranchContentMetaData(),
      keywords: ['Plugin', 'Branch', 'Flutter'],
      publiclyIndex: true,
      locallyIndex: true,
      expirationDateInMilliSec:
          DateTime.now().add(const Duration(days: 365)).millisecondsSinceEpoch);

  @override
  logReserveEvent(room) async {
    var event = BranchEvent.standardEvent(BranchStandardEvent.PURCHASE)
      ..currency = BranchCurrencyType.USD
      ..revenue = room.price
      ..tax = 10
      ..transactionID =
          '${room.roomId}_${Get.find<UserModel>().customerId}_${DateFormatter.formatWithTime(DateTime.now())}';
    FlutterBranchSdk.trackContent(buo: [_buo], branchEvent: event);
  }

  @override
  logLogInEvent() {
    FlutterBranchSdk.trackContent(
        buo: [_buo],
        branchEvent: BranchEvent.standardEvent(BranchStandardEvent.LOGIN));
  }

  @override
  logLogOutEvent() {
    FlutterBranchSdk.trackContent(
        buo: [_buo], branchEvent: BranchEvent.customEvent('LOGOUT'));
  }
}
