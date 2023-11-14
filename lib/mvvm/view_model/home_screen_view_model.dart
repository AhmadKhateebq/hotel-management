import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/mvvm/repository/room/room_api.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreenViewModel {
  PanelController panelController = PanelController();
  TextEditingController adultController = TextEditingController();
  TextEditingController bedsController = TextEditingController();
  double maxPriceCanChoose = 1000;
  double minPriceCanChoose = 0;
  late RangeValues priceRange;
  double rating = 0;
  int adults = 2;
  int beds = 1;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  List<bool> stars = [true, true, true, true, true];
  bool seaView = false;
  var rooms = <Room>[].obs;
  bool isSearching = false;
  var loading = true.obs;
  var isFilterShowing = false.obs;

  void init() {
    bedsController.text = '$beds';
    adultController.text = '$adults';
    priceRange = RangeValues(minPriceCanChoose, maxPriceCanChoose);
    getRooms();
  }

  void getUserData() {
    Get.find<SupabaseAuthController>().getUserData();
  }

  openFilters() {
    panelController.isPanelOpen
        ? panelController.close()
        : panelController.open();
    isFilterShowing.value = !isFilterShowing.value;
  }

  get getDrawer =>
      Get
          .find<SupabaseAuthController>()
          .loginUser
          .getDrawer();

  get addRoom =>
      (Get
          .find<SupabaseAuthController>()
          .loginUser
          .role == ROLE.admin)
          ? FloatingActionButton(
        // title: Text("add".tr),
        onPressed: () {
          Get.offAllNamed('/add_room');
        },
        child: const Icon(Icons.add, color: Colors.black),
      )
          : const SizedBox();

  Future<void>getRooms() async {
    isFilterShowing.value = false;
    loading.value = true;
    rooms.value = await RoomApi().getEmptyRooms(
      start: startDate,
      end: endDate,
    );
    await Future.delayed(const Duration(milliseconds: 250));
    loading.value = false;
  }


  getRoomsFiltered(Map<String, dynamic> filters, bool seaView) async {
    filters.forEach((key, value) {
      log('$value', name: key);
    });
    if (isSearching) {
      return;
    }
    loading.value = true;
    isFilterShowing.value = false;
    int adult = filters['adult'] ?? 0;
    int bed = filters['bed'] ?? 0;
    double max = filters['max'] ?? 10000;
    double min = filters['min'] ?? 0;
    int rating1 = filters['rating1'] ?? 1;
    int rating2 = filters['rating2'] ?? 2;
    int rating3 = filters['rating3'] ?? 3;
    int rating4 = filters['rating4'] ?? 4;
    int rating5 = filters['rating5'] ?? 5;
    isSearching = true;
    rooms.value = await RoomApi().getEmptyRoomsFiltered(
      start: startDate,
      end: endDate,
      adult: adult,
      bed: bed,
      max: max,
      min: min,
      rating1: rating1,
      rating2: rating2,
      rating3: rating3,
      rating4: rating4,
      rating5: rating5,
    );
    if (seaView) {
      rooms.value = rooms.where((room) => room.seaView).toList();
    }
    loading.value = false;
    isSearching = false;
  }
}
