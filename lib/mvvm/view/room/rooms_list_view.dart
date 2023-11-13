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
    return ListView(
      children: listViewBuilderOneLine,
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
    return list;
  }
}
