import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';

import '../../view_model/room/room_preview_view_model.dart';
import '../components/rating_bar.dart';

class PreviewRoom extends StatelessWidget {
  const PreviewRoom({
    super.key, required this.viewModel,
  });
 final RoomPreviewViewModel viewModel;
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
                  back: CustomRatingBar(
                    rating: viewModel.stars,
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
                  ),Text('Beds : ${viewModel.beds} Bed${viewModel.beds>1?'s':''} '),
                  const SizedBox(
                    height: 20,
                  ),Text('Size : ${viewModel.adults} Adult${viewModel.adults>1?'s':''} '),
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
          child: Image.network(
            url,
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
