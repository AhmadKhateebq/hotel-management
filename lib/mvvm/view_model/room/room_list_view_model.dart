import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/model/room.dart';

class RoomListViewModel {
  final DateTime startDate;
  final DateTime endDate;

  int currentFloor = 0;
  final List<Room> rooms;

  RoomListViewModel({
    required this.rooms,
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
}
