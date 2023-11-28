import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hotel_management/model/request/all_request_model.dart';
import 'package:hotel_management/interface/request.dart';
import 'package:hotel_management/model/request/my_request_model.dart';
import 'package:hotel_management/model/request/requests_model.dart';
import 'package:hotel_management/view/request/request_details_view.dart';

class RequestsListViewModel with ChangeNotifier {
  final bool? pending;
  final bool? approved;
  final bool? intertwined;
  final bool? denied;
  final bool myRequests;
  late final RequestModel model;
  bool _mounted = false;
  late StreamSubscription streamSubscriber;

  RequestsListViewModel({
    required this.pending,
    required this.approved,
    required this.intertwined,
    required this.denied,
    required this.myRequests,
  }) {
    model =
        myRequests ? Get.find<MyRequestModel>() : Get.find<AllRequestModel>();
    streamSubscriber = model.stream.listen(updateRequestsOnDataChange);
    updateRequests();
  }

  List<RoomRequest> get requests => model.filteredRequests;

  Future<void> updateRequests() async {
    model.setUpFlags(
        pending: pending,
        denied: denied,
        approved: approved,
        intertwined: intertwined,
        myRequests: myRequests);
    model.getRequests().then((value) => notify());
  }

   updateRequestsOnDataChange(
      List<Map<String, dynamic>> data)  {
     model.setUpFlags(
         pending: pending,
         denied: denied,
         approved: approved,
         intertwined: intertwined,
         myRequests: myRequests);
    final temp = data.map(RoomRequest.fromDynamicMap).toList();
    model.updateWithData(temp);
     notify();
  }

  notify() {
    if (!_mounted) {
      try {
        notifyListeners();
      } catch (e, s) {
        if (kDebugMode) {
          print(e);
          print(s);
        }
      }
    }
  }

  get length => model.filteredRequests.length;

  request(int index) => model.filteredRequests[index];

  void init() {
    model.setUpFlags(
        pending: pending,
        denied: denied,
        approved: approved,
        intertwined: intertwined,
        myRequests: myRequests);
  }

  cardOnTap(RoomRequest request) {
    Get.to(
      () => PreviewRequest(
        request: request,
      ),
      duration: const Duration(milliseconds: 500),
      transition: Transition.circularReveal,
      curve: Curves.easeInExpo,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _mounted = true;
    streamSubscriber.cancel();
  }
}
