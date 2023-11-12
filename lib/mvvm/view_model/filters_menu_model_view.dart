import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class FilterMenuModelView {
  final PanelController panelController;
  DateTimeRange range = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(const Duration(days: 1)));
  var start = DateFormatter
      .format(DateTime.now())
      .obs;
  var end =
      DateFormatter
          .format(DateTime.now().add(const Duration(days: 1)))
          .obs;
  TextEditingController adultController = TextEditingController();
  TextEditingController bedsController = TextEditingController();
  static const double minPriceCanChoose = 0;
  static const double maxPriceCanChoose = 1000;
  var seaView = false.obs;
  var priceRange = const RangeValues(minPriceCanChoose, maxPriceCanChoose).obs;
  double maxPrice = 1000;
  double minPrice = 0;
  RxList<bool> stars = [false, false, false, false, false].obs;

  FilterMenuModelView({required this.panelController});

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

  getRatingWidget(int index) =>
      Column(
        children: [
          Text('$index Star${index > 1 ? 's' : ''}'),
          Obx(
             () => Checkbox(value: stars[index], onChanged: (val) {
                stars[index] = val!;
              })
          )
        ],
      );

  applyFilters() {
    if (panelController.isPanelOpen){
      print('search');
      panelController.close();
    }
  }
}
