import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/database_controller.dart';
import 'package:hotel_management/controller/requests_controller.dart';
import 'package:hotel_management/model/request.dart';
import 'package:hotel_management/model/room.dart';
import 'package:hotel_management/pages/component/room_preview.dart';
import 'package:hotel_management/util/util_classes.dart';

class RoomsListView extends StatefulWidget {
  const RoomsListView(
      {super.key,
      required this.startDate,
      required this.endDate,
      this.filters});

  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic>? filters;

  @override
  State<RoomsListView> createState() => _RoomsListViewState();
}

class _RoomsListViewState extends State<RoomsListView> {
  final SupabaseDatabaseController databaseController = Get.find();
  var loading = true;
  int currentFloor = 0;
  List<Room> rooms = [];

  @override
  void initState() {
    getRooms();
    super.initState();
  }

  @override
  void didUpdateWidget(RoomsListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    getRooms();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const CircularProgressIndicator()
        : ListView(
            children: listViewBuilderOneLine(rooms),
          );
  }

  listViewBuilderOneLine(List<Room> rooms) {
    int index = 0;
    List<Widget> list = <Widget>[];
    for (index; index < rooms.length; index++) {
      Room room = rooms[index];
      var floor = int.parse(room.roomId.replaceAll(RegExp(r'[^0-9]'), ''));
      if (floor != currentFloor) {
        currentFloor = floor;
        list.add(getDivider(floor));
        list.add(getListTile(room, index));
      } else {
        list.add(getListTile(room, index));
      }
    }
    return list;
  }

  Widget getDivider(int floor) {
    return ListTile(title: Text(getFloorText(floor)));
    // return Column(
    //     children: [
    //       const Divider(
    //         color: Colors.black,
    //         thickness: 2,
    //       ),
    //       Text(getFloorText(floor)),
    //       const Divider(
    //         color: Colors.black,
    //         thickness: 2,
    //       ),
    //     ],
    //   );
  }

  Widget getListTile(Room room, int index) {
    var floor = int.parse(room.roomId.replaceAll(RegExp(r'[^0-9]'), ''));
    var stars = getStarts(room.stars);
    return InkWell(
      onTap: () {
        Get.to(PreviewRoom(
          room: room,
          stars: stars,
        ));
      },
      child: Card(
        child: Row(
          children: [
            SizedBox(
              width: Get.width * (1 / 2),
              height: Get.height * (1 / 6),
              child: Image.network(room.pictureUrl),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Room ${room.roomId}',
                          style: const TextStyle(
                            // color: Colors.green,
                            fontWeight: FontWeight.bold,
                            // fontStyle: FontStyle.italic,
                            fontSize: 20,
                          )),
                      Text(getFloorText(floor),style: const TextStyle(
                        // color: Colors.green,
                        // fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                      )),
                      Text(room.seaView ? 'Sea View ' : '',style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                      )),
                      Row(
                        children: stars,
                      ),
                    ],
                  ),
                  Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Text(
                        '${room.price} \$',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  getImageText(String text) => Text(
        text,
        style: const TextStyle(color: Colors.white),
      );

  reserveRoom(
    String roomId,
    DateTime startingDate,
    DateTime endingDate,
  ) async {
    if (databaseController.currentCustomerRole == ROLE.customer) {
      RoomRequest request = RoomRequest(
          id: 0,
          time: DateTime.now(),
          startingDate: startingDate,
          endingDate: endingDate,
          status: STATUS.pending,
          roomId: roomId,
          customerId: databaseController.currentCustomerDetails.customerId);
      await Get.find<RoomRequestController>().addRoomRequest(request);
    }
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

  String getFloorText(int floor) {
    return floor == 1
        ? 'First Floor'
        : floor == 2
            ? 'Second Floor'
            : '${floor}th Floor';
  }

  getRooms() async {
    rooms = await databaseController.getEmptyRooms(
      start: widget.startDate,
      end: widget.endDate,
    );
    setState(() {
      loading = false;
    });
  }
}

class HalfFilledIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const HalfFilledIcon({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect rect) {
        return LinearGradient(
          stops: const [0, 0.5, 0.5],
          colors: [color, color, color.withOpacity(0)],
        ).createShader(rect);
      },
      child: SizedBox(
        child: Icon(icon, color: Colors.grey[300]),
      ),
    );
  }
}
