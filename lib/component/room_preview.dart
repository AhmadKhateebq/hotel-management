import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/scaffold_widget.dart';
import 'package:hotel_management/controller/database_controller.dart';
import 'package:hotel_management/controller/requests_controller.dart';
import 'package:hotel_management/model/request.dart';
import 'package:hotel_management/model/room.dart';
import 'package:hotel_management/util/util_classes.dart';

class PreviewRoom extends StatelessWidget {
  const PreviewRoom({
    super.key,
    required this.room,
    required this.stars,
    required this.requestController,
    required this.databaseController,
  });

  final RoomRequestController requestController;

  final SupabaseDatabaseController databaseController;

  final Room room;
  final List<Widget> stars;

  @override
  Widget build(BuildContext context) {
    return ScaffoldBuilder(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close)),
        backgroundColor: Colors.redAccent,
        title: Text('Room ${room.roomId}'),
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
                  children: stars,
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
                  Text('Price : ${room.price} \$'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Floor : ${getFloor()}'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: reserveRoom, child: const Text('Apply Now'))
                ],
              ),
            ),
          ],
        ),
      ),
      title: '',
    );
  }

  Widget setSlideShow() {
    List<Widget> images = [getImage(room.pictureUrl)];
    for (var value in room.slideshow ?? []) {
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
    var floor = int.parse(room.roomId.replaceAll(RegExp(r'[^0-9]'), ''));
    return floor == 1
        ? 'First Floor'
        : floor == 2
        ? 'Second Floor'
        : '${floor}th Floor';
  }

  reserveRoom() async {
    if (databaseController.start.day == databaseController.end.day &&
        databaseController.start.month == databaseController.end.month &&
        databaseController.start.year == databaseController.end.year ) {
      await pickDates();
    }
    var a = await requestController.addRoomRequest(RoomRequest(
        id: 0,
        roomId: room.roomId,
        customerId: databaseController.currentCustomerDetails.customerId,
        time: DateTime.now(),
        startingDate: databaseController.start,
        endingDate: databaseController.end,
        status: STATUS.pending));
    Get.snackbar(a ? "Room Applied" : "You already applied for this room", '');
  }

  Future<DateTime> pickDate({DateTime? startingDate}) async {
    return (await showDatePicker(
      helpText: startingDate == null
          ? "Chose a starting date"
          : "Chose an Ending date",
      context: Get.context!,
      initialDate: startingDate ?? DateTime.now(),
      firstDate: startingDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDatePickerMode: DatePickerMode.year,
    )) ??
        DateTime.now();
  }

  Future<void> pickDates() async {
    databaseController.start = await pickDate();
    databaseController.end =
    await pickDate(startingDate: databaseController.start);
  }
}
