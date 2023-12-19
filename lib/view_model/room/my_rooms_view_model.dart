import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/model/room/my_room_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyRoomsViewModel {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final PanelController panelController = PanelController();
  final MyRoomModel _model = MyRoomModel();
  var loading = true.obs;
  var empty = false.obs;
  double stars = 0;

  get currentRoom => _model.currentRoom;

  get rooms => _model.rooms;

  MyRoomsViewModel({this.scaffoldKey});

  init() async {
    await _model.init();
    loading.value = false;
    if (_model.rooms.isEmpty) {
      loading.value = false;
      empty.value = true;
    }
  }

  void onTap(int index) {
    if (currentRoom.value != rooms[index]) {
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

   submit() async {
    if (Get.find<ConnectivityController>().connected.value) {
       _model.submit(stars);
    } else {
      Get.snackbar('No Internet Connection', 'try again later');
    }
  }

  void reserveNow() {
    if (scaffoldKey != null) {
      Get.back();
    }
    Get.back();
  }
}
