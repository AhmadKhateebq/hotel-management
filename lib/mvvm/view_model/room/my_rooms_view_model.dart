import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/mvvm/repository/my_rooms_facade.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyRoomsViewModel {
  var loading = true.obs;
  var empty = false.obs;
  final PanelController panelController = PanelController();
  List<Room> rooms = [];
  double stars = 0;
  late Rx<Room> currentRoom;
  final MyRoomsFacade facade = MyRoomsFacade();
  void init() async {
    rooms = await facade.getRooms();
    if(rooms.isNotEmpty){
      currentRoom = Rx(rooms[0]);
      stars = currentRoom.value.stars;
      loading.value = false;
    }else{
      loading.value = false;
      empty.value = true;
    }

  }

  void onTap(int index) {
    if(currentRoom.value != rooms[index]){
      currentRoom.value = rooms[index];
      stars = currentRoom.value.stars;
    }
    if(!panelController.isPanelOpen){
      panelController.open();
    }else{
      panelController.close();
    }
  }
  void setStars(double value) {
    stars = value;
  }

  void submit() {
    if(Get.find<ConnectivityController>().connected.value){
      facade.submitReview(currentRoom.value.roomId,stars);
    }
   else{
     Get.snackbar('No Internet Connection', 'try again later');
    }
    panelController.close();
  }

  void reserveNow() {
    Get.offNamed('/home');
  }
}
