import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hotel_management/component/custom_drawer.dart';
import 'package:hotel_management/view/request/requests_list_page_view.dart';

class RequestsPageViewModel {
  late TabController tabController;
  final PageController pageController = PageController();
  Timer? _timer;
  final bool _myRequests;

  RequestsPageViewModel({bool? myRequests})
      : _myRequests = myRequests ?? false;
  get drawer => _myRequests ?  null:const CustomDrawer() ;

  get title =>
      _myRequests ? const Text('My Requests') : const Text('All Requests');


  get requests => [
        RequestsList(
          pending: false,
          approved: false,
          intertwined: false,
          denied: false,
          myRequests: _myRequests,
        ),
        RequestsList(
          pending: true,
          approved: false,
          intertwined: false,
          denied: false,
          myRequests: _myRequests,
        ),
        RequestsList(
          pending: false,
          approved: true,
          intertwined: false,
          denied: false,
          myRequests: _myRequests,
        ),
        RequestsList(
          pending: false,
          approved: false,
          intertwined: true,
          denied: false,
          myRequests: _myRequests,
        ),
        RequestsList(
          pending: false,
          approved: false,
          intertwined: false,
          denied: true,
          myRequests: _myRequests,
        ),
      ];

  get icons => const [
        Icons.home,
        Icons.access_time_rounded,
        Icons.check,
        Icons.compare_arrows,
        Icons.close,
      ];

  get functions => [
        () {
          homeButton(0);
        },
        () {
          homeButton(1);
        },
        () {
          homeButton(2);
        },
        () {
          homeButton(3);
        },
        () {
          homeButton(4);
        }
      ];

  // get getUser => _auth.loginUser;

  void init(TickerProvider val) {
    // getUserData();
    tabController = TabController(length: 5, vsync: val);
  }

  changeIcon(int index) {
    tabController.animateTo(index);
  }

  onPageChange(int index) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(milliseconds: 200), () {
      tabController.animateTo(index);
    });
  }

  // getRequestsStream() => _requestApi.getRequestsStream();

  onTapItem(int index) {
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    // notifyListeners();
  }

  homeButton(int index) {
    onTapItem(index);
    changeIcon(index);
  }
}
