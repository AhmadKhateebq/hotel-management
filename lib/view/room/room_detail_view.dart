import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/interface/room.dart';

import '../../view_model/room/room_details_view_model.dart';
import '../../component/rating/rating_bar.dart';

class RoomDetailsView extends StatefulWidget {
  const RoomDetailsView({super.key, this.room, this.id, this.fromDeepLink});

  final Room? room;
  final String? id;
  final bool? fromDeepLink;

  @override
  State<RoomDetailsView> createState() => _RoomDetailsViewState();
}

class _RoomDetailsViewState extends State<RoomDetailsView> {
  late final RoomDetailsViewModel viewModel;

  @override
  void initState() {
    viewModel = RoomDetailsViewModel(
        room: widget.room,
        id: widget.id,
        fromDeepLink: widget.fromDeepLink ?? false);
    viewModel.init().then((value) {

      setState(() {});
      if (value) {
        viewModel.reserveRoom();
      }
    });
    super.initState();
  }

  TextStyle get labelStyle =>
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey);

  TextStyle get detailStyle => const TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (viewModel.fromDeepLink) {
                Get.offNamed('/home');
              } else {
                Get.back();
              }
            },
            icon: const Icon(Icons.close)),
        title: Text('Room ${viewModel.roomId}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: FlipCard(
                  front: setSlideShow(),
                  back: Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomRatingBar(
                          rating: viewModel.avg.value,
                        ),
                        Text(viewModel.avg.value.toStringAsFixed(2)),
                      ],
                    ),
                  )),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 0,
              color: Colors.grey,
            ),
            const Text(
              'Room Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price', style: labelStyle),
                      Text('Beds', style: labelStyle),
                      Text('Size', style: labelStyle),
                      Text('Floor', style: labelStyle),
                    ],
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 0,
                    color: Colors.grey,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${viewModel.price} \$', style: detailStyle),
                      Text(
                          '${viewModel.beds} Bed${viewModel.beds > 1 ? 's' : ''} ',
                          style: detailStyle),
                      Text(
                          '${viewModel.adults} Adult${viewModel.adults > 1 ? 's' : ''} ',
                          style: detailStyle),
                      Text('${getFloor(viewModel.roomId)}', style: detailStyle),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 20,
              endIndent: 0,
              color: Colors.grey,
            ),
            TextButton(
              onPressed: viewModel.reserveRoom,
              child: const Text(
                'Apply Now',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setSlideShow() {
    List<Widget> images = [getImage(viewModel.pictureUrl)];
    for (var value in viewModel.slideshow) {
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
          child: Get.find<ConnectivityController>().connected.value
              ? Image.network(
                  url,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/image/noImage.png',
                  fit: BoxFit.cover,
                ),
        ));
  }

  getFloor(String roomId) {
    var floor = int.parse(roomId.replaceAll(RegExp(r'[^0-9]'), ''));
    return floor == 1
        ? 'First Floor'
        : floor == 2
            ? 'Second Floor'
            : '${floor}th Floor';
  }
}
