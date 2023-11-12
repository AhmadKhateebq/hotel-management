import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/mvvm/view/room/room_card.dart';
import 'package:hotel_management/mvvm/view_model/room/room_card_view_model.dart';
import 'package:hotel_management/mvvm/view_model/room/room_list_view_model.dart';

class RoomsListView extends StatefulWidget {
  const RoomsListView({
    super.key,
    required this.viewModel,
  });

  final RoomListViewModel viewModel;

  @override
  State<RoomsListView> createState() => _RoomsListViewState();
}
class _RoomsListViewState extends State<RoomsListView> {
  @override
  void initState() {
    widget.viewModel.getRooms();
    super.initState();
  }

  @override
  void didUpdateWidget(RoomsListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.viewModel.getRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.viewModel.loading.value
        ? const CircularProgressIndicator()
        : ListView(
      children: listViewBuilderOneLine,
    ));
  }
  get listViewBuilderOneLine {
    int index = 0;
    List<Widget> list = <Widget>[];
    for (index; index < widget.viewModel.rooms.length; index++) {
      Room room = widget.viewModel.rooms[index];
      list.add(widget.viewModel.divider(room.roomId));
      list.add(RoomCard(viewModel: RoomCardViewModel(room: room)));
    }
    return list;
  }
}
