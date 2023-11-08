import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/requests_controller.dart';
import 'package:hotel_management/model/request.dart';
import 'package:hotel_management/model/room.dart';
import 'package:hotel_management/util/util_classes.dart';

class PreviewRoom extends StatefulWidget {
  const PreviewRoom({
    super.key,
    required this.room,
    required this.stars,
  });

  final Room room;
  final List<Widget> stars;

  @override
  State<PreviewRoom> createState() => _PreviewRoomState();
}

class _PreviewRoomState extends State<PreviewRoom> {
  late final RoomRequestController requestController;

  late final UtilityClass util;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  bool roomApplied = false;

  @override
  void initState() {
    util = Get.find();
    requestController = Get.find();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close)),
        title: Text('Room ${widget.room.roomId}'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: FlipCard(
                front: setSlideShow(),
                back: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: widget.stars,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Price : ${widget.room.price} \$'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Floor : ${getFloor()}'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(

                    onPressed: reserveRoom,
                    child:  Text('Apply Now',style: TextStyle(
                      color: roomApplied?Colors.grey:null
                    ),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setSlideShow() {
    List<Widget> images = [getImage(widget.room.pictureUrl)];
    for (var value in widget.room.slideshow ?? []) {
      images.add(getImage(value));
    }
    return ImageSlideshow(
      isLoop: true,
      autoPlayInterval: 5000,
      children: images,
    );
  }

  getImage(String url) {
    return SizedBox(
        height: 250,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            url,
            fit: BoxFit.cover,
          ),
        ));
  }

  getFloor() {
    var floor = int.parse(widget.room.roomId.replaceAll(RegExp(r'[^0-9]'), ''));
    return floor == 1
        ? 'First Floor'
        : floor == 2
            ? 'Second Floor'
            : '${floor}th Floor';
  }

  reserveRoom() async {
    if(!roomApplied){
      if (startDate.day == startDate.day &&
          startDate.month == startDate.month &&
          startDate.year == startDate.year) {
        var dates = await util.dateRangePicker();
        if (dates != null) {
          startDate = dates.start;
          endDate = dates.end;
        }
      }
      var a = await requestController.addRoomRequest(RoomRequest(
          id: 0,
          roomId: widget.room.roomId,
          customerId: util.customerId,
          time: DateTime.now(),
          startingDate: startDate,
          endingDate: endDate,
          status: STATUS.pending));
      Get.snackbar(a ? "Room Applied" : "You already applied for this room", '');
      setState(() {
        roomApplied = !a;
        print(roomApplied);
      });
    }
  }
}
