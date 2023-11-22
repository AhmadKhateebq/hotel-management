import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/mvvm/repository/request/room_request_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomRequestLocal extends RoomRequestRepository {
  final SharedPreferences _prefs = SharedPrefController.reference;

  @override
  approve(int id, String roomId) async {
    List<Request> approved = getCachedApprove();
    approved.add(Request(id: id, roomId: roomId));
    await _prefs.setStringList('approve', approved.map(jsonEncode).toList());
    Get.back();
    Get.snackbar('No Internet Connection',
        'The request will go when you have internet connection');
  }

  List<Request> getCachedApprove() {
    List<Request> approved = [];
    if (_prefs.containsKey('approve')) {
      approved = _prefs
          .getStringList('approve')!
          .map(jsonDecode)
          .map(Request.fromDynamic)
          .toList();
    }
    return approved;
  }

  @override
  autoApprove(String roomId) async {
    Get.snackbar('No Internet Connection',
        'You cant request an Auto Approve,try again later');
  }


  @override
  deny(int id, String roomId) async {
    List<Request> denied = getCachedDeny();
    denied.add(Request(id: id, roomId: roomId));
    await _prefs.setStringList(
        'deny', denied.map((e) => e.toJson()).map(jsonEncode).toList());
    Get.back();
    Get.snackbar('No Internet Connection',
        'The request will go when you have internet connection');
  }

  List<Request> getCachedDeny() {
    List<Request> denied = [];
    if (_prefs.containsKey('deny')) {
      denied = _prefs
          .getStringList('deny')!
          .map(jsonDecode)
          .map(Request.fromDynamic)
          .toList();
    }
    return denied;
  }

  @override
  reserveRoom(String roomId, String customerId, DateTimeRange dates) async {
    List<ReserveRequest> reserve = getCachedReserveRoom();
    reserve.add(ReserveRequest(
        roomId: roomId,
        customerId: customerId,
        startingDate: dates.start,
        endingDate: dates.end));
    await _prefs.setStringList(
        'approve', reserve.map((e) => e.toJson()).map(jsonEncode).toList());
    Get.back();
    Get.snackbar('No Internet Connection',
        'The request will go when you have internet connection');
  }

  List<ReserveRequest> getCachedReserveRoom() {
    List<ReserveRequest> reserve = [];
    if (_prefs.containsKey('reserve')) {
      reserve = _prefs
          .getStringList('reserve')!
          .map(jsonDecode)
          .map(ReserveRequest.fromDynamic)
          .toList();
    }
    return reserve;
  }

  saveRoomRequestToPref(List<RoomRequest> requests) async {
    await _prefs.setStringList(
        'requests', requests.map((e) => e.toJson()).map(jsonEncode).toList());
  }

  List<RoomRequest> getAllRequests() {
    return _prefs
        .getStringList('requests')!
        .map(jsonDecode)
        .map(RoomRequest.fromDynamic)
        .toList();
  }

  @override
  addRoomRequest(RoomRequest request) {
    Get.snackbar('No Internet Connection', 'Cant add room in offline mode');
  }

  @override
  Future<List<RoomRequest>> getRoomRequests() async {
    return getAllRequests();
  }

  @override
  setUpListener(void Function() func) {
    throw UnimplementedError();
  }

  Future<void> emptyCachedRequests() async {
    await _prefs.remove('approve');
    await _prefs.remove('deny');
    await _prefs.remove('reserve');
  }
}

class Request {
  final int id;
  final String roomId;

  Request({required this.id, required this.roomId});

  factory Request.fromDynamic(dynamic data) =>
      Request(id: data['id'], roomId: data['room_id']);

  Map<String, dynamic> toJson() => {
        'room_id': roomId,
        'id': id,
      };
}

class ReserveRequest {
  final String roomId;
  final String customerId;
  final DateTime startingDate;
  final DateTime endingDate;

  ReserveRequest(
      {required this.roomId,
      required this.customerId,
      required this.startingDate,
      required this.endingDate});

  factory ReserveRequest.fromDynamic(dynamic data) => ReserveRequest(
      roomId: data['room_id'],
      customerId: data['customer_id'],
      startingDate: DateTime.parse(data['starting_date']),
      endingDate: DateTime.parse(data['ending_date']));

  Map<String, dynamic> toJson() => {
        'room_id': roomId,
        'customer_id': customerId,
        'starting_date': (startingDate).toString(),
        'ending_date': (endingDate).toString(),
      };
}
