import 'package:flutter/material.dart';
import 'package:hotel_management/component/room/room_card.dart';
import 'package:hotel_management/interface/room.dart';

// ignore: must_be_immutable
class RoomCardList extends StatelessWidget {
  RoomCardList({
    super.key,
    required this.rooms,
    required this.onRefresh, required this.onTap,
  });

  final Future<void> Function() onRefresh;
  final void Function(Room) onTap;
  final List<Room> rooms;
  int currentFloor = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> rooms = roomsListBuilder();
    bool shrink = false;
    if (rooms.length == 1) {
      if (rooms.first.runtimeType == Center) {
        shrink = true;
      }
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      strokeWidth: 4.0,
      child: ListView(
        shrinkWrap: shrink,
        children: rooms,
      ),
    );
  }

  List<Widget> roomsListBuilder() {
    int index = 0;
    List<Widget> list = <Widget>[];
    for (index; index < rooms.length; index++) {
      Room room = rooms[index];
      list.add(divider(room.roomId));
      list.add(RoomCard(
        room: room, onTap:onTap,
      ));
    }
    if (list.isEmpty) {
      list.add(const Center(
        child: Text('No Rooms Available'),
      ));
    }
    return list;
  }

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
