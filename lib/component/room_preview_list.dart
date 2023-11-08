import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/room_preview.dart';
import 'package:hotel_management/component/rooms_list_view.dart';
import 'package:hotel_management/model/room.dart';

class RoomsPreviewList extends StatelessWidget {
  const RoomsPreviewList({super.key, this.initialPage, required this.list});

  final int? initialPage;
  final List<Room> list;

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: initialPage ?? 0);
    return SafeArea(
      child: PageView(
        allowImplicitScrolling: true,
        scrollDirection: Axis.horizontal,
        controller: controller,
        children: _list,
      ),
    );
  }

  List<PreviewRoom> get _list {
    List<PreviewRoom> rooms = [];
    for (Room value in list) {
      rooms.add(PreviewRoom(
        room: value,
        stars: getStarts(value.stars), requestController: Get.find(), databaseController: Get.find(),
      ));
    }
    return rooms;
  }

  getStarts(double stars) {
    List<Widget> starList = [];
    int i = 0;
    while (i < 5) {
      if (stars >= 1) {
        starList.add(const Icon(
          Icons.star,
          fill: .5,
          color: Colors.orange,
        ));
        stars = stars - 1;
      } else if (stars < 1 && stars > 0) {
        starList
            .add(const HalfFilledIcon(icon: Icons.star, color: Colors.orange));
        stars = 0;
      } else if (stars == 0) {
        starList.add(Icon(
          Icons.star,
          color: Colors.grey[300],
        ));
      }
      i++;
    }
    return starList;
  }
}
