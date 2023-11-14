import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/mvvm/view/room/room_card.dart';
import 'package:hotel_management/mvvm/view_model/room/room_card_view_model.dart';
import 'package:hotel_management/mvvm/view_model/room/room_list_view_model.dart';

class RoomsListView extends StatelessWidget {
  const RoomsListView({
    super.key,
    required this.viewModel,
  });

  final RoomListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    List<Widget> a = listViewBuilderOneLine;
    bool shrink = false;
    if (a.length == 1) {
      if (a.first.runtimeType == Center) {
        shrink = true;
      }
    }
    return RefreshIndicator(
      onRefresh: viewModel.onRefresh,
      strokeWidth: 4.0,
      child: ListView(
        shrinkWrap: shrink,
        children: a,
      ),
    );
  }

  get listViewBuilderOneLine {
    int index = 0;
    List<Widget> list = <Widget>[];
    for (index; index < viewModel.rooms.length; index++) {
      Room room = viewModel.rooms[index];
      list.add(viewModel.divider(room.roomId));
      list.add(RoomCard(viewModel: RoomCardViewModel(room: room)));
    }
    if (list.isEmpty) {
      list.add(const Center(
        child: Text('No Rooms Available'),
      ));
    }
    return list;
  }
}
