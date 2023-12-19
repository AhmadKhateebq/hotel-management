import 'package:get/get.dart';
import 'package:hotel_management/analytics/analytics_abstract.dart';
import 'package:hotel_management/analytics/branch_analytics_impl.dart';
import 'package:hotel_management/analytics/firebase_analytics_impl.dart';
import 'package:hotel_management/interface/room.dart';

class AnalyticsService extends GetxController {
  final List<HotelAnalytics> _subscribers = [
    FirebaseAnalyticsImpl(),
    BranchAnalyticsImpl(),
  ];

  logLogOut() {
    for (var element in _subscribers) {
      element.logLogOutEvent();
    }
  }

  logLogIn() {
    for (var element in _subscribers) {
      element.logLogInEvent();
    }
  }

  logReserve(Room room) {
    for (var element in _subscribers) {
      element.logReserveEvent(room);
    }
  }

  addSubscriber(HotelAnalytics analyticsService) {
    _subscribers.add(analyticsService);
  }
}
