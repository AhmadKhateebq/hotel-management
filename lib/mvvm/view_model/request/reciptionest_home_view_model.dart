import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/view/requests/requests_list_page.dart';
import 'package:hotel_management/mvvm/view_model/request/request_list_view_model.dart';

class ReceptionHomeViewModel with ChangeNotifier {
  late TabController tabController;

  // final SupabaseAuthController _auth = Get.find();
  final PageController controller = PageController();
  Timer? _timer;

  get requests => [
        RequestsList(
          viewModel: RequestsListViewModel(
            pending: false,
            approved: false,
            intertwined: false,
            denied: false,
            myRequests: false,
            // mapper: RoomRequest.fromDynamicMap,
          ),
        ),
        RequestsList(
          viewModel: RequestsListViewModel(
            pending: true,
            approved: false,
            intertwined: false,
            denied: false,
            myRequests: false,
            // mapper: RoomRequest.fromDynamicMap,
          ),
        ),
        RequestsList(
          viewModel: RequestsListViewModel(
            pending: false,
            approved: true,
            intertwined: false,
            denied: false,
            myRequests: false,
            // mapper: RoomRequest.fromDynamicMap,
          ),
        ),
        RequestsList(
          viewModel: RequestsListViewModel(
            pending: false,
            approved: false,
            intertwined: true,
            denied: false,
            myRequests: false,
            // mapper: RoomRequest.fromDynamicMap,
          ),
        ),
        RequestsList(
          viewModel: RequestsListViewModel(
            pending: false,
            approved: false,
            intertwined: false,
            denied: true,
            myRequests: false,
            // mapper: RoomRequest.fromDynamicMap,
          ),
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
    controller.animateToPage(index,
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    // notifyListeners();
  }

  homeButton(int index) {
    onTapItem(index);
    changeIcon(index);
  }
}
