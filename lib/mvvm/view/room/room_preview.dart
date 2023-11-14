import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';

import '../../view_model/room/room_preview_view_model.dart';
import '../components/rating_bar.dart';

class PreviewRoom extends StatefulWidget {
  const PreviewRoom({
    super.key, required this.viewModel,
  });
 final RoomPreviewViewModel viewModel;

  @override
  State<PreviewRoom> createState() => _PreviewRoomState();
}

class _PreviewRoomState extends State<PreviewRoom> {
  @override
  void initState() {
    widget.viewModel.getAvg();
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
        title: Text('Room ${widget.viewModel.roomId}'),
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
                    ()=> Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomRatingBar(
                          rating: widget.viewModel.avg.value,
                        ),
                        Text(widget.viewModel.avg.value.toStringAsFixed(2)),
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
                  Text('Price : ${widget.viewModel.price} \$'),
                  const SizedBox(
                    height: 20,
                  ),Text('Beds : ${widget.viewModel.beds} Bed${widget.viewModel.beds>1?'s':''} '),
                  const SizedBox(
                    height: 20,
                  ),Text('Size : ${widget.viewModel.adults} Adult${widget.viewModel.adults>1?'s':''} '),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Floor : ${getFloor(widget.viewModel.roomId)}'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: widget.viewModel.reserveRoom,
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
    List<Widget> images = [getImage(widget.viewModel.pictureUrl)];
    for (var value in widget.viewModel.slideshow) {
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
