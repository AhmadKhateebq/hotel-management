// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/mvvm/repository/room/room_api.dart';
import 'package:hotel_management/mvvm/repository/room/room_local.dart';
import 'package:hotel_management/mvvm/repository/room/room_repository.dart';

class RoomCache extends RoomRepository {
  RoomLocal local = RoomLocal();
  late RoomApi api;
  bool _init = false;

  RoomCache() {
    _isOnline().then((value) async {
      if (value) {
        if (!_init) {
          api = RoomApi();
          await api.init();
          _setUpListener();
          _init = true;
        }
      }
    });
  }

  _setUpListener() {
    Get.find<ConnectivityController>().subscription.onData((data) async {
      if (data == ConnectivityResult.wifi ||
          data == ConnectivityResult.mobile) {
        if (!_init) {
          api = RoomApi();
          await api.init();
          _init = true;
        }
      }
    });
  }

  @override
  Future<List<Room>> getEmptyRooms(
      {required DateTime start, required DateTime end}) async {
    if (await _isOnline()) {
      var temp = await api.getEmptyRooms(start: start, end: end);
      await local.saveRoomsToPref(temp);
      return temp;
    } else {
      return await local.getEmptyRooms(start: start, end: end);
    }
  }

  @override
  Future<List<Room>> getEmptyRoomsFiltered(
      {required DateTime start,
      required DateTime end,
      required int adult,
      required int bed,
      required double max,
      required double min,
      required int rating1,
      required int rating2,
      required int rating3,
      required int rating4,
      required int rating5}) async {
    if (await _isOnline()) {
      return await api.getEmptyRoomsFiltered(
          start: start,
          end: end,
          adult: adult,
          bed: bed,
          max: max,
          min: min,
          rating1: rating1,
          rating2: rating2,
          rating3: rating3,
          rating4: rating4,
          rating5: rating5);
    } else {
      return await local.getEmptyRoomsFiltered(
          start: start,
          end: end,
          adult: adult,
          bed: bed,
          max: max,
          min: min,
          rating1: rating1,
          rating2: rating2,
          rating3: rating3,
          rating4: rating4,
          rating5: rating5);
    }
  }

  @override
  getMyRooms({required String userId}) async {
    if (await _isOnline()) {
      return await api.getMyRooms(userId: userId);
    } else {
      return await local.getMyRooms(userId: userId);
    }
  }

  @override
  getNextID(String floor) async {
    if (await _isOnline()) {
      return await api.getNextID(floor);
    } else {
      return await local.getNextID(floor);
    }
  }

  @override
  Future<void> saveRoom(Room room) async {
    if (await _isOnline()) {
      return await api.saveRoom(room);
    } else {
      return await local.saveRoom(room);
    }
  }

  @override
  Future<String> uploadImage(File file, String roomId) async {
    if (await _isOnline()) {
      return await api.uploadImage(file, roomId);
    } else {
      return await local.uploadImage(file, roomId);
    }
  }

  @override
  validateData(String floor) async {
    if (await _isOnline()) {
      return api.validateData(floor);
    } else {
      return local.validateData(floor);
    }
  }

  final Connectivity _connectivity = Connectivity();

  Future<bool> _isOnline() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      if(result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile){
        await init();
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return false;
    }
  }

  init() async {
    try{
      if (!_init) {
        api = RoomApi();
        await api.init();
        _setUpListener();
        _init = true;
      }
    }catch (e){
      if(kDebugMode){
        print(e);
      }
    }
  }
}
