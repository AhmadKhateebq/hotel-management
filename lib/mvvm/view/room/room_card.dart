import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/mvvm/view/components/rating_bar.dart';
import 'package:hotel_management/mvvm/view_model/room/room_card_view_model.dart';
import 'package:hotel_management/mvvm/view/components/flow/parallax_image.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.viewModel});

  final RoomCardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: viewModel.isHistory ? null : viewModel.onTap,
      child: Card(
        child: Row(
          children: [
            SizedBox(
              width: Get.width * (1.1 / 2),
              height: Get.height * (1.1 / 6),
              // child: Image.network(viewModel.pictureUrl),
              child: Obx(
                () => Get.find<ConnectivityController>().connected.value
                    ? ParallaxImage(
                        imageUrl: viewModel.pictureUrl,
                      )
                    : Image.asset(
                        'assets/image/noImage.png',
                        fit: BoxFit.cover,
                      ),
              ),
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
                      Text('Room ${viewModel.roomId}',
                          style: const TextStyle(
                            // color: Colors.green,
                            fontWeight: FontWeight.bold,
                            // fontStyle: FontStyle.italic,

                            fontSize: 20,
                          )),
                      Text(viewModel.floorText,
                          style: const TextStyle(
                            // color: Colors.green,
                            // fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 15,
                          )),
                      Text(viewModel.seaView,
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                          )),
                      CustomRatingBar(
                        rating: viewModel.stars,
                      ),
                    ],
                  ),
                  Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Text(
                        '${viewModel.price} \$',
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
}
