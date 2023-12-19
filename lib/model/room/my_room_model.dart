import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hotel_management/interface/room.dart';
import 'package:hotel_management/repository/my_rooms_facade.dart';

class MyRoomModel{
  List<Room> rooms = [];
  final MyRoomsFacade _facade = MyRoomsFacade();
  late Rx<Room> currentRoom;
  init() async {
    rooms = await _facade.getRooms();
    if(rooms.isNotEmpty){
      currentRoom = Rx(rooms[0]);
    }
  }
  submit(double stars) async {
    await _facade.submitReview(currentRoom.value.roomId, stars);
  }
}