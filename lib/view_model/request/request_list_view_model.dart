import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
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
  late final RequestModel _model;
  bool _mounted = false;
  StreamSubscription? _streamSubscriber;

  RequestsListViewModel({
    required this.pending,
    required this.approved,
    required this.intertwined,
    required this.denied,
    required this.myRequests,
  }) {
    _model =
        myRequests
            ? Get.find<MyRequestModel>()
            : Get.find<AllRequestModel>();
    setUpConnectivityListener();
    updateRequests();
  }
  setUpConnectivityListener(){
    if(Get.find<ConnectivityController>().connected.value) {
      _streamSubscriber = _model.stream.listen(updateRequestsOnDataChange);
    }
    Get.find<ConnectivityController>().subscription.onData((data) {
      if(data == ConnectivityResult.wifi ||data == ConnectivityResult.ethernet ||data == ConnectivityResult.mobile ){
        _streamSubscriber ??= _model.stream.listen(updateRequestsOnDataChange);
        if(_streamSubscriber!.isPaused){
          _streamSubscriber!.resume();
        }
      }else{
        if(_streamSubscriber != null){
          _streamSubscriber!.pause();
        }
      }
    });
  }
  List<RoomRequest> get requests => _model.filteredRequests;

  Future<void> updateRequests() async {
    _model.setUpFlags(
        pending: pending,
        denied: denied,
        approved: approved,
        intertwined: intertwined,
        myRequests: myRequests);
    _model.getRequests().then((value) => notify());
  }

   updateRequestsOnDataChange(
      List<Map<String, dynamic>> data)  {
     _model.setUpFlags(
         pending: pending,
         denied: denied,
         approved: approved,
         intertwined: intertwined,
         myRequests: myRequests);
    List<RoomRequest> temp = data.map(RoomRequest.fromDynamicMap).toList();
    _model.updateWithData(temp);
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

  get length => _model.filteredRequests.length;

  request(int index) => _model.filteredRequests[index];

  void init() {
    _model.setUpFlags(
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
    _streamSubscriber?.cancel();
  }
}
