import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/interface/room.dart';
import 'package:hotel_management/model/room/room_model.dart';
import 'package:hotel_management/model/user_model.dart';
import 'package:hotel_management/repository/customer/customer_api.dart';
import 'package:hotel_management/repository/request/room_request_repository.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomDetailsViewModel {
  Room _room = Room(
      roomId: '0',
      seaView: false,
      beds: 0,
      stars: 0,
      adults: 0,
      pictureUrl: noImage,
      price: 0);
  String? _id;
  RxDouble avg = RxDouble(0);
  bool fromDeepLink;
  DateTime? startingDate;
  DateTime? endingDate;

  RoomDetailsViewModel({
    Room? room,
    String? id,
    required this.fromDeepLink,
  }) {
    _id = id;
    if (room != null) {
      _room = room;
    } else {
      if (_id == null) {
        if (Get.parameters.isNotEmpty) {
          _id = Get.parameters['roomId'];
          fromDeepLink = true;
        }
      }
    }
  }

  Future<bool> init() async {
    if (_id != null) {
      setRoom(await getRoom(_id!));
    }
    final queryParams = Get.parameters;
    if (queryParams.containsKey('date')) {
      final param1 = queryParams['date'];
      final param2 = queryParams['date2'];
      try {
        startingDate = DateFormatter.parseFromParam(param1!);
        endingDate = DateFormatter.parseFromParam(param2!);
        return true;
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  final RoomRequestRepository requestApi = Get.find();

  final CustomerApi customerApi = Get.find();

  get room => _room;

  get roomId => _room.roomId;

  get stars => _room.stars;

  get price => _room.price;

  String get pictureUrl => _room.pictureUrl;

  get slideshow => _room.slideshow ?? [];

  get beds => _room.beds;

  get adults => _room.adults;

  Future<void> reserveRoom() async {
    DateTimeRange? dates = await _dateRangePicker();

    if (dates != null) {
      var customerId = Get.find<UserModel>().customerId;
      requestApi.reserveRoom(roomId, customerId, dates);
    }
  }

  Future<DateTimeRange?> _dateRangePicker() async {
    return await showDateRangePicker(
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 1461)),
        initialDateRange: DateTimeRange(
            start: startingDate ?? DateTime.now(),
            end: endingDate ?? DateTime.now().add(const Duration(days: 1))),
        context: Get.context!);
  }

  getAvg() async {
    avg.value = await getAvgReview(_room.roomId);
  }

  Future<double> getAvgReview(String roomId) async {
    double avg = 0;
    if (!Get.find<ConnectivityController>().connected.value) {
      return avg;
    }
    var ratings = await Supabase.instance.client
        .from('review')
        .select<List>('rating')
        .eq('room_id', roomId);
    void addAvg(dynamic value) {
      avg += double.parse(value['rating'].toString());
    }

    if (ratings.isNotEmpty) {
      ratings.forEach(addAvg);
      avg /= ratings.length;
    }
    return avg;
  }

  Future<Room> getRoom(String id) async {
    return await Get.find<RoomModel>().getRoom(id);
  }

  setRoom(Room value) {
    _room = value;
  }
}
