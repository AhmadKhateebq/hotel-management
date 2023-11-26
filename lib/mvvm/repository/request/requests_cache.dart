import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/mvvm/repository/request/requests_api.dart';
import 'package:hotel_management/mvvm/repository/request/room_request_local.dart';
import 'package:hotel_management/mvvm/repository/request/room_request_repository.dart';

class RoomRequestCache extends RoomRequestRepository {
  RoomRequestLocal local = RoomRequestLocal();
  late RoomRequestApi api;
  void Function()? _function;
  late StreamSubscription subscription;
  bool _init = false;

  RoomRequestCache() {
    _isOnline().then((value) async {
      if (value) {
        if (!_init) {
          api = RoomRequestApi();
          await api.init();
          subscription = _setUpListener();
          _init = true;
        }
        await _emptyCache();
      }
    });
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
        await _emptyCache();
        refreshData();
      } else {
        subscription.pause();
      }
    });
  }

  @override
  addRoomRequest(RoomRequest request) async {
    if (await _isOnline()) {
      api.addRoomRequest(request);
    } else {
      local.addRoomRequest(request);
    }
  }

  @override
  approve(int id, String roomId) async {
    if (await _isOnline()) {
      await api.approve(id, roomId);
    } else {
      await local.approve(id, roomId);
    }
  }

  @override
  autoApprove(String roomId) async {
    if (await _isOnline()) {
      await api.autoApprove(roomId);
    } else {
      await local.autoApprove(roomId);
    }
  }

  @override
  deny(int id, String roomId) async {
    if (await _isOnline()) {
      await api.deny(id, roomId);
    } else {
      await local.deny(id, roomId);
    }
  }

  @override
  Future<List<RoomRequest>> getRoomRequests() async {
    return local.getAllRequests();
  }

  @override
  reserveRoom(String roomId, String customerId, DateTimeRange dates) async {
    if (await _isOnline()) {
      await api.reserveRoom(roomId, customerId, dates);
    } else {
      Get.snackbar('No Internet Connection', 'try again later');
    }
  }

  @override
  setUpListener(void Function() func) {
    _function = func;
  }

  final Connectivity _connectivity = Connectivity();

  Future<bool> _isOnline() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        await init();
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return false;
    }
  }

  _setUpListener() {
    var listener = api.getStream().listen((event) async {
      List<RoomRequest> temp = event.map(RoomRequest.fromDynamicMap).toList();
      if (temp != await getRoomRequests()) {
        await local.saveRoomRequestToPref(temp);
        if (_function != null) {
          _function!.call();
        }
      }
    });
    return listener;
  }

  _emptyCache() async {
    var approved = local.getCachedApprove();
    var denied = local.getCachedDeny();
    var reserve = local.getCachedReserveRoom();
    if (approved.isNotEmpty) {
      for (var value in approved) {
        await approve(value.id, value.roomId);
      }
    }
    if (denied.isNotEmpty) {
      for (var value in denied) {
        await deny(value.id, value.roomId);
      }
    }
    if (reserve.isNotEmpty) {
      for (var value in reserve) {
        await reserveRoom(value.roomId, value.customerId,
            DateTimeRange(start: value.startingDate, end: value.endingDate));
      }
    }
    await local.emptyCachedRequests();

    if (_function != null) {
      _function!.call();
    }
  }

  Future<void> refreshData() async {
    List<RoomRequest> temp = await api.getRoomRequests();
    await local.saveRoomRequestToPref(temp);
    if (_function != null) {
      _function!.call();
    }
  }

  init() async {
    try {
      if (!_init) {
        api = RoomRequestApi();
        await api.init();
        _setUpListener();
        _init = true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<List<RoomRequest>> getMyRoomRequests() async {
    if (await _isOnline()) {
      return await api.getMyRoomRequests();
    } else {
      return await local.getMyRoomRequests();
    }
  }
}
