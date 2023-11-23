import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/model/room.dart';

class RoomListViewModel {
  Future<void> Function() onRefresh;
  int currentFloor = 0;
  final List<Room> rooms;

  RoomListViewModel({
    required this.rooms,
    required this.onRefresh,
  });

  Widget divider(roomId) {
    var floor = int.parse(roomId.replaceAll(RegExp(r'[^0-9]'), ''));
    if (floor != currentFloor) {
      currentFloor = floor;
      return (_getDivider(floor));
    } else {
      return const SizedBox();
    }
  }

  Widget _getDivider(int floor) {
    return ListTile(title: Text(_getFloorText(floor)));
  }

  String _getFloorText(int floor) {
    return floor == 1
        ? 'First Floor'
        : floor == 2
            ? 'Second Floor'
            : '${floor}th Floor';
  }
}
