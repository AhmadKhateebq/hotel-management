import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class FilterMenuModelView {
  final PanelController panelController;
  DateTimeRange range = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(const Duration(days: 1)));
  var start = DateFormatter.format(DateTime.now()).obs;
  var end =
      DateFormatter.format(DateTime.now().add(const Duration(days: 1))).obs;
  TextEditingController adultController = TextEditingController();
  TextEditingController bedsController = TextEditingController();
  static const double minPriceCanChoose = 0;
  static const double maxPriceCanChoose = 1000;
  var seaView = false.obs;
  var priceRange = const RangeValues(minPriceCanChoose, maxPriceCanChoose).obs;
  double maxPrice = 5500;
  double minPrice = 0;
  RxList<bool> stars = [false, false, false, false, false].obs;
  Function(Map<String, dynamic> filters, bool seaView) search;

  FilterMenuModelView({required this.panelController, required this.search});

  Future<DateTimeRange> dateRangePicker() async {
    return await showDateRangePicker(
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 1461)),
            context: Get.context!) ??
        DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 1)));
  }

  Future<void> pickDate() async {
    range = await dateRangePicker();
    start.value = DateFormatter.format(range.start);
    end.value = DateFormatter.format(range.end);
  }

  setSeaView(bool value) {
    seaView.value = value;
  }

  changePriceRange(RangeValues value) {
    maxPrice = value.end;
    minPrice = value.start;
    if (minPrice > maxPrice) {
      maxPrice = minPrice;
    }
    priceRange.value = RangeValues(minPrice, maxPrice);
  }

  getRatingWidget(int index) => Column(
        children: [
          Text('${index + 1} Star${index > 1 ? 's' : ''}'),
          Obx(() => Checkbox(
              value: stars[index],
              onChanged: (val) {
                stars[index] = val!;
              }))
        ],
      );

  applyFilters() {
    if (panelController.isPanelOpen) {
      panelController.close();
    }
    int beds = int.tryParse(bedsController.text) ?? 0;
    int adult = int.tryParse(adultController.text) ?? 0;
    var list = getRating();
    search({
      'max': maxPrice,
      'min': minPrice,
      'bed': beds,
      'adult': adult,
      'rating1': list[0],
      'rating2': list[1],
      'rating3': list[2],
      'rating4': list[3],
      'rating5': list[4],
    }, seaView.value);
  }

  List<int> getRating() {
    try {
      stars.firstWhere((element) => element == true);
      int max = 0;
      var ratings = [0, 0, 0, 0, 0];
      if (stars[0] == true) {
        ratings[0] = 1;
        max = 1;
      }
      if (stars[1] == true) {
        ratings[1] = 2;
        max = 2;
      }
      if (stars[2] == true) {
        ratings[2] = 3;
        max = 3;
      }
      if (stars[3] == true) {
        ratings[3] = 4;
        max = 4;
      }
      if (stars[4] == true) {
        ratings[4] = 5;
        max = 5;
      }
      return ratings.map((e) => e == 0 ? max : e).toList();
    } catch (e) {
      return [1, 2, 3, 4, 5];
    }
  }
}
