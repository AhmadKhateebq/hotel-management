import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
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
  Map<String, dynamic> filters = {
    'price_min': 0,
    'price_max': double.infinity,
    'rating': 0,
  };

  void init() {
    bedsController.text = '$beds';
    adultController.text = '$adults';
    priceRange = RangeValues(minPriceCanChoose, maxPriceCanChoose);
  }

  void getUserData() {
    Get.find<SupabaseAuthController>().getUserData();
  }

  openFilters() {
    panelController.isPanelOpen
        ? panelController.close()
        : panelController.open();
  }

  get getDrawer =>  Get.find<SupabaseAuthController>().loginUser.getDrawer();

  get addRoom => (Get.find<SupabaseAuthController>().loginUser.role == ROLE.admin)
      ? FloatingActionButton(
          // title: Text("add".tr),
          onPressed: () {
            Get.toNamed('/add_room');
          },
          child: const Icon(Icons.add, color: Colors.black),
        )
      : const SizedBox();

}
