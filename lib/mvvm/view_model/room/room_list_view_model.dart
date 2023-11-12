import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/mvvm/repository/room/room_api.dart';

class RoomListViewModel {
  final DateTime startDate;
  final DateTime endDate;
  var loading = true.obs;
  int currentFloor = 0;
  List<Room> rooms = [];

  RoomListViewModel({
    required this.startDate,
    required this.endDate,
  });

  Widget divider(roomId) {
    var floor = int.parse(roomId.replaceAll(RegExp(r'[^0-9]'), ''));
    if (floor != currentFloor) {
      currentFloor = floor;
      return (getDivider(floor));
    } else {
      return const SizedBox();
    }
  }

  Widget getDivider(int floor) {
    return ListTile(title: Text(getFloorText(floor)));
  }

  String getFloorText(int floor) {
    return floor == 1
        ? 'First Floor'
        : floor == 2
            ? 'Second Floor'
            : '${floor}th Floor';
  }

  getRooms() async {
    rooms = await RoomApi().getEmptyRooms(
      start: startDate,
      end: endDate,
    );
    loading.value = false;
  }
}
