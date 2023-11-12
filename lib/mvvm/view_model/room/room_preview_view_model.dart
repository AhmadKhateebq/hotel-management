import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/mvvm/repository/request/requests_api.dart';
import 'package:hotel_management/mvvm/model/room.dart';

class RoomPreviewViewModel {
  final Room _room;

  RoomPreviewViewModel({required Room room}) : _room = room;

  get room => _room;

  get roomId => _room.roomId;

  get stars => _room.stars;

  get price => _room.price;

  String get pictureUrl => _room.pictureUrl;

  get slideshow => _room.slideshow ?? [];

  Future<void> reserveRoom() async {
    DateTimeRange dates = await _dateRangePicker() ??
        DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 1)));
    var customerId = Get.find<SupabaseAuthController>().loginUser.user!.id;
    Get.find<RoomRequestApi>().reserveRoom(roomId, customerId, dates);
  }

  _dateRangePicker() async {
    return await showDateRangePicker(
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 1461)),
        context: Get.context!);
  }
}
