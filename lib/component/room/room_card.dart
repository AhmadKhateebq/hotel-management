import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/animation/flow/parallax_image_flow.dart';
import 'package:hotel_management/component/rating/rating_bar.dart';
import 'package:hotel_management/interface/room.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({
    super.key,
    required Room room,
    this.onTap,
  }) : _room = room;

  final Room _room;
  final void Function(Room)? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap!(_room) : null,
      child: Card(
        child: Row(
          children: [
            SizedBox(
                width: Get.width * (1.1 / 2),
                height: Get.height * (1.1 / 6),
                // child: Image.network(viewModel.pictureUrl),
                child: ParallaxImage(
                  imageUrl: _room.pictureUrl,
                )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Room ${_room.roomId}',
                          style: const TextStyle(
                            // color: Colors.green,
                            fontWeight: FontWeight.bold,
                            // fontStyle: FontStyle.italic,

                            fontSize: 20,
                          )),
                      Text(floorText,
                          style: const TextStyle(
                            // color: Colors.green,
                            // fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 15,
                          )),
                      Text(seaView,
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                          )),
                      CustomRatingBar(
                        rating: _room.stars,
                      ),
                    ],
                  ),
                  Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Text(
                        '${_room.price} \$',
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

  String get floorText {
    var floor = int.parse(_room.roomId.replaceAll(RegExp(r'[^0-9]'), ''));
    return '${floor == 1 ? 'First Floor' : floor == 2 ? 'Second Floor' : '${floor}th Floor'} '
        '\nRoom ${_room.roomId.replaceAll(RegExp(r'[^A-Z]'), '')}';
  }

  String get seaView => _room.seaView ? 'Sea View ' : '';
}
