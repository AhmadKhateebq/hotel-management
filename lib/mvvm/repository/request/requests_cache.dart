import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/mvvm/repository/request/requests_api.dart';
import 'package:hotel_management/mvvm/repository/request/room_request_local.dart';
import 'package:hotel_management/mvvm/repository/request/room_request_repository.dart';

class RoomRequestCache extends RoomRequestRepository {
  RoomRequestLocal local = RoomRequestLocal();
  late RoomRequestApi api;
  late void Function() _function;
  late StreamSubscription subscription;
  bool _init = false;

  RoomRequestCache() {
    Get.find<ConnectivityController>().subscription.onData((data) async {
      if (data == ConnectivityResult.wifi ||
          data == ConnectivityResult.mobile) {
        if (!_init) {
          api = RoomRequestApi();
          await api.init();
          subscription = _setUpListener();
          _init = true;
        }
        subscription.resume();
        _emptyCache();
      } else {
        subscription.pause();
      }
    });
  }

  @override
  addRoomRequest(RoomRequest request) {
    if (_isOnline) {
      api.addRoomRequest(request);
    } else {
      local.addRoomRequest(request);
    }
  }

  @override
  approve(int id, String roomId) {
    if (_isOnline) {
      api.approve(id, roomId);
    } else {
      local.approve(id, roomId);
    }
  }

  @override
  autoApprove(String roomId) {
    if (_isOnline) {
      api.autoApprove(roomId);
    } else {
      local.autoApprove(roomId);
    }
  }

  @override
  deny(int id, String roomId) {
    if (_isOnline) {
      api.deny(id, roomId);
    } else {
      local.deny(id, roomId);
    }
  }

  @override
  Future<List<RoomRequest>> getRoomRequests() async {
    return local.getAllRequests();
  }

  @override
  reserveRoom(String roomId, String customerId, DateTimeRange dates) {
    if (_isOnline) {
      api.reserveRoom(roomId, customerId, dates);
    }
  }

  @override
  setUpListener(void Function() func) {
    _function = func;
  }

  bool get _isOnline => Get.find<ConnectivityController>().isOnline;

  _setUpListener() {
    var listener = api.getStream().listen((event) async {
      List<RoomRequest> temp = event.map(RoomRequest.fromDynamicMap).toList();
      if (temp != await getRoomRequests()) {
        await local.saveRoomRequestToPref(temp);
        _function.call();
      }
    });
    return listener;
  }

  _emptyCache() {
    var approved = local.getCachedApprove();
    var denied = local.getCachedDeny();
    var reserve = local.getCachedReserveRoom();
    if (approved.isNotEmpty) {
      for (var value in approved) {
        approve(value.id, value.roomId);
      }
    }
    if (denied.isNotEmpty) {
      for (var value in denied) {
        deny(value.id, value.roomId);
      }
    }
    if (reserve.isNotEmpty) {
      for (var value in reserve) {
        reserveRoom(value.roomId, value.customerId,
            DateTimeRange(start: value.startingDate, end: value.endingDate));
      }
    }
  }
}
