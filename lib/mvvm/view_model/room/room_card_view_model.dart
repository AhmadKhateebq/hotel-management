import 'package:hotel_management/mvvm/model/room.dart';

class RoomCardViewModel{
  final Room _room;

  RoomCardViewModel({required room}): _room = room;

  Room get room => _room;
  String get pictureUrl => _room.pictureUrl;

  get roomId => _room.roomId;

  String get floorText {
    var floor = int.parse(_room.roomId.replaceAll(RegExp(r'[^0-9]'), ''));
    return floor == 1
        ? 'First Floor'
        : floor == 2
        ? 'Second Floor'
        : '${floor}th Floor';
  }

  String get seaView => _room.seaView? 'Sea View ' : '';

  get stars => _room.stars;

  get price => _room.price;

}