import 'dart:developer';

import 'package:flutter/material.dart';

class MyRequestsViewModel with ChangeNotifier{
  late TabController tabController;
  bool pending = false;
  bool approved = false;
  bool intertwined = false;
  bool denied = false;


  void init(TickerProvider val) {
    tabController = TabController(length: 5, vsync: val);
  }


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