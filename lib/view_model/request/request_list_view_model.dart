import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hotel_management/model/request_model.dart';
import 'package:hotel_management/interface/request.dart';
import 'package:hotel_management/view/request/request_details_view.dart';


class RequestsListViewModel with ChangeNotifier {
  final bool? pending;
  final bool? approved;
  final bool? intertwined;
  final bool? denied;
  final bool myRequests;
  final RequestModel model = Get.find();

  // final RoomRequest Function(Map<String, dynamic> data) mapper;

  RequestsListViewModel({
    required this.pending,
    required this.approved,
    required this.intertwined,
    required this.denied,
    required this.myRequests,
  }) {
    model.setUpListener(updateRequests);
    updateRequests().then((_)=>notify());
  }

  List<RoomRequest> get requests => model.filteredRequests;

  Future<void> updateRequests() async {
    model.setUpFlags(
        pending: pending,
        denied: denied,
        approved: approved,
        intertwined: intertwined,
        myRequests: myRequests);
    if (myRequests) {
      await model.getMyRequests();
    } else {
      await model.getRequests();
    }
    notify();
  }
  notify(){
    try{
      notifyListeners();
    }catch(e){
      if(kDebugMode){
        print(e);
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
}
