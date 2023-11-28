import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hotel_management/view/request/requests_list_page_view.dart';

class ReceptionHomeViewModel with ChangeNotifier {
  late TabController tabController;

  // final SupabaseAuthController _auth = Get.find();
  final PageController controller = PageController();
  Timer? _timer;

  get requests => [
        const RequestsList(

            pending: false,
            approved: false,
            intertwined: false,
            denied: false,
            myRequests: false,
            // mapper: RoomRequest.fromDynamicMap,

        ),
        const RequestsList(

            pending: true,
            approved: false,
            intertwined: false,
            denied: false,
            myRequests: false,
            // mapper: RoomRequest.fromDynamicMap,

        ),
        const RequestsList(
            pending: false,
            approved: true,
            intertwined: false,
            denied: false,
            myRequests: false,
            // mapper: RoomRequest.fromDynamicMap,

        ),
        const RequestsList(

            pending: false,
            approved: false,
            intertwined: true,
            denied: false,
            myRequests: false,
            // mapper: RoomRequest.fromDynamicMap,

        ),
        const RequestsList(

            pending: false,
            approved: false,
            intertwined: false,
            denied: true,
            myRequests: false,
            // mapper: RoomRequest.fromDynamicMap,

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
