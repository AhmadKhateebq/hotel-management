import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
// ignore: unused_import
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/mvvm/repository/request/room_request_repository.dart';
import 'package:hotel_management/util/util_classes.dart';

class RequestsListViewModel with ChangeNotifier {
  final bool? pending;
  final bool? approved;
  final bool? intertwined;
  final bool? denied;

  // final RoomRequest Function(Map<String, dynamic> data) mapper;
  final RoomRequestRepository requestRepository = Get.find();
  List<RoomRequest> requests = <RoomRequest>[];

  RequestsListViewModel({
    required this.pending,
    required this.approved,
    required this.intertwined,
    required this.denied,
    // required this.mapper
  }) {
    requestRepository.setUpListener(updateRequests);

  }

  get length => requests.length;

  // Stream<List<Map<String, dynamic>>> get dataStream => Get.find<RoomRequestRepository>().getRequestsStream();
  bool filterRequests(RoomRequest request) {
    bool a = true;
    if (approved ?? false) {
      a = request.status == STATUS.approved;
    }
    if (pending ?? false) {
      a = request.status == STATUS.pending;
    }
    if (intertwined ?? false) {
      a = request.status == STATUS.reserved;
    }
    if (denied ?? false) {
      a = request.status == STATUS.denied;
    }
    return a;
  }

  request(int index) => requests[index];

  Future<void> updateRequests() async {
    var temp =
        (await requestRepository.getRoomRequests()).where(filterRequests).toList();
    if (requests != temp) {
      requests = temp;
      try {
        notifyListeners();
      } catch (e) {
        if (kDebugMode) {}
      }
    }
  }
}
