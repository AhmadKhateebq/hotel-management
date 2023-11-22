import 'package:get/get.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/mvvm/view/room/room_preview.dart';

import 'room_preview_view_model.dart';

class RoomCardViewModel {
  final Room _room;
  final bool isHistory;

  RoomCardViewModel({required room, bool? isHistory})
      : _room = room,
        isHistory = isHistory ?? false;

  Room get room => _room;

  String get pictureUrl => _room.pictureUrl;

  get roomId => _room.roomId;

  String get floorText {
    var floor = int.parse(_room.roomId.replaceAll(RegExp(r'[^0-9]'), ''));
    return '${floor == 1 ? 'First Floor' : floor == 2 ? 'Second Floor' : '${floor}th Floor'} '
        '\nRoom ${_room.roomId.replaceAll(RegExp(r'[^A-Z]'), '')}';
  }

  String get seaView => _room.seaView ? 'Sea View ' : '';

  get stars => _room.stars;

  get price => _room.price;

  void onTap() {
    if (!isHistory) {
      Get.to(() => PreviewRoom(
            viewModel: RoomPreviewViewModel(
                room: room,
                ),
          ));
    }
  }
}
