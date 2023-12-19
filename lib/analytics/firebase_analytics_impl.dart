import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:hotel_management/analytics/analytics_abstract.dart';
import 'package:hotel_management/interface/room.dart';
import 'package:hotel_management/model/user_model.dart';

class FirebaseAnalyticsImpl
    extends HotelAnalytics
{
  final _analytics = FirebaseAnalytics.instance;

  // FirebaseAnalyticsImpl({required super.eventStream, required super.roomStream});
  @override
  logLogInEvent() async {
    await _analytics.logEvent(
        name: 'logged_in',
        parameters: {'user_id': Get.find<UserModel>().customerId});
  }

  @override
  logLogOutEvent() async {
    await _analytics.logEvent(
        name: 'logged_out',
        parameters: {'user_id': Get.find<UserModel>().customerId});
  }

  @override
  logReserveEvent(Room room) async {
    await _analytics.logPurchase(value: room.price, currency: 'USD');
  }
}
