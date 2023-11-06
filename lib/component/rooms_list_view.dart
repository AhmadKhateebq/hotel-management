import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/database_controller.dart';
import 'package:hotel_management/controller/requests_controller.dart';
import 'package:hotel_management/model/request.dart';
import 'package:hotel_management/model/room.dart';
import 'package:hotel_management/util/util_classes.dart';

class RoomsListView extends StatefulWidget {
  const RoomsListView({super.key});

  @override
  State<RoomsListView> createState() => _RoomsListViewState();
}

class _RoomsListViewState extends State<RoomsListView> {
  final SupabaseDatabaseController databaseController = Get.find();
  late Stream<List<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    _stream = databaseController.getRoomsStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          print(snapshot.data);
          List<Room> rooms =
              snapshot.data?.map((e) => Room.fromDynamicMap(e)).toList() ?? [];
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              Room room = rooms[index];
              return listTileBuilder(room);
            },
          );
        });
  }

  ListTile listTileBuilder(Room room) {

    return ListTile(
      title: Text(room.roomId),
      subtitle: Text(room.reserved?"Reserved":"Free"),
      onTap: () => listTileOnTap(room.roomId),
    );
  }

  listTileOnTap(String roomId) async {
    if (databaseController.currentCustomerRole == ROLE.customer) {
      RoomRequest request = RoomRequest(
          id: 0,
          time: DateTime.now(),
          startingDate: DateTime.now(),
          endingDate: DateTime.now().add(const Duration(days: 120)),
          status: STATUS.pending,
          roomId: roomId,
          customerId: databaseController.currentCustomerDetails.customerId);
      await Get.find<RoomRequestController>().addRoomRequest(request);
    }
    print(roomId);
  }
}
