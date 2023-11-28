import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/interface/room.dart';
import 'package:hotel_management/repository/my_rooms_facade.dart';
class MyRoomsViewModel {
  var loading = true.obs;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  var empty = false.obs;
  List<Room> rooms = [];
  double stars = 0;
  late Rx<Room> currentRoom;
  final MyRoomsFacade facade = MyRoomsFacade();
  MyRoomsViewModel({this.scaffoldKey});
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
  }

  void reserveNow() {
    if(scaffoldKey!=null){
      Get.back();
    }
    Get.back();
  }
}
