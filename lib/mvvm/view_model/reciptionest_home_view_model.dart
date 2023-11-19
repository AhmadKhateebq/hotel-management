import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/mvvm/repository/request/requests_api.dart';
import 'package:hotel_management/mvvm/view/requests/requests_list_page.dart';
import 'package:hotel_management/mvvm/view_model/request/request_list_view_model.dart';

class ReceptionHomeViewModel with ChangeNotifier {
  late TabController tabController;
  final RoomRequestApi _requestApi = RoomRequestApi();
  final SupabaseAuthController _auth = Get.find();
  final PageController controller = PageController();
  Timer? _timer;

  get requests => [
        RequestsList(
          viewModel: RequestsListViewModel(
            pending: false,
            approved: false,
            intertwined: false,
            denied: false,
            dataStream: getRequestsStream(),
            mapper: RoomRequest.fromDynamicMap,
          ),
        ),
        RequestsList(
          viewModel: RequestsListViewModel(
            pending: true,
            approved: false,
            intertwined: false,
            denied: false,
            dataStream: getRequestsStream(),
            mapper: RoomRequest.fromDynamicMap,
          ),
        ),
        RequestsList(
          viewModel: RequestsListViewModel(
            pending: false,
            approved: true,
            intertwined: false,
            denied: false,
            dataStream: getRequestsStream(),
            mapper: RoomRequest.fromDynamicMap,
          ),
        ),
        RequestsList(
          viewModel: RequestsListViewModel(
            pending: false,
            approved: false,
            intertwined: true,
            denied: false,
            dataStream: getRequestsStream(),
            mapper: RoomRequest.fromDynamicMap,
          ),
        ),
        RequestsList(
          viewModel: RequestsListViewModel(
            pending: false,
            approved: false,
            intertwined: false,
            denied: true,
            dataStream: getRequestsStream(),
            mapper: RoomRequest.fromDynamicMap,
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

  void getUserData() {
    _auth.getUserData();
  }

  void init(TickerProvider val) {
    getUserData();
    tabController = TabController(length: 5, vsync: val);
  }

  changeIcon(int index) {
    tabController.animateTo(index);
  }

  onPageChange(int index) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(milliseconds: 120), () {
      tabController.animateTo(index);
    });
  }

  getRequestsStream() => _requestApi.getRequestsStream();

  getDrawer() => _auth.loginUser.getDrawer();

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
