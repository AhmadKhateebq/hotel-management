import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/mvvm/repository/request/requests_api.dart';

class ReceptionHomeViewModel with ChangeNotifier{
  late TabController tabController;
  final RoomRequestApi _requestApi = RoomRequestApi();
  final SupabaseAuthController _auth = Get.find();
  bool pending = false;
  bool approved = false;
  bool intertwined = false;
  bool denied = false;

  void getUserData() {
    _auth.getUserData();
  }

  void init(TickerProvider val) {
    getUserData();
    tabController = TabController(length: 5, vsync: val);
  }

  getRequestsStream() => _requestApi.getRequestsStream();

  getDrawer() => _auth.loginUser.getDrawer();

  onTapItem(int index) {
    if (index == 0) {
      pending = false;
      approved = false;
      intertwined = false;
      denied = false;
    }
    if (index == 1) {
      pending = true;
      approved = false;
      intertwined = false;
      denied = false;
    }
    if (index == 2) {
      pending = false;
      approved = true;
      intertwined = false;
      denied = false;
    }
    if (index == 3) {
      pending = false;
      approved = false;
      intertwined = true;
      denied = false;
    }
    if (index == 4) {
      pending = false;
      approved = false;
      intertwined = false;
      denied = true;
    }
    log('$pending',name: 'pending');
    log('$approved',name: 'approved');
    log('$intertwined',name: 'intertwined');
    log('$denied',name: 'denied');
    notifyListeners();
  }
}