import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/interface/room.dart';

import '../../view_model/room/room_details_view_model.dart';
import '../../component/rating/rating_bar.dart';

class RoomDetailsView extends StatefulWidget {
  const RoomDetailsView({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  State<RoomDetailsView> createState() => _RoomDetailsViewState();
}

class _RoomDetailsViewState extends State<RoomDetailsView> {
  late final RoomDetailsViewModel viewModel ;

  @override
  void initState() {
    viewModel = RoomDetailsViewModel(room: widget.room);
    viewModel.getAvg();
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
        title: Text('Room ${viewModel.roomId}'),
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Price : ${viewModel.price} \$'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      'Beds : ${viewModel.beds} Bed${viewModel.beds > 1 ? 's' : ''} '),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      'Size : ${viewModel.adults} Adult${viewModel.adults > 1 ? 's' : ''} '),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Floor : ${getFloor(viewModel.roomId)}'),
                  const SizedBox(
                    height: 20,
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
