import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class FiltersCustomMenu extends StatefulWidget {
  const FiltersCustomMenu(
      {super.key,
      required this.panelController,
      required this.searchOnClick,
      required this.resetOnClick});

  final PanelController panelController;
  final Function(Map<String, dynamic> filters, bool seaView) searchOnClick;
  final Function() resetOnClick;

  @override
  State<FiltersCustomMenu> createState() => _FiltersCustomMenuState();
}

class _FiltersCustomMenuState extends State<FiltersCustomMenu> {
  final int count = 5;
  DateTimeRange range = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(const Duration(days: 1)));
  var start = DateFormatter.format(DateTime.now()).obs;
  var end =
      DateFormatter.format(DateTime.now().add(const Duration(days: 1))).obs;
  TextEditingController adultController = TextEditingController();
  TextEditingController bedsController = TextEditingController();
  static const double minPriceCanChoose = 0;
  static const double maxPriceCanChoose = 5500;
  var seaView = false.obs;
  var priceRange = const RangeValues(minPriceCanChoose, maxPriceCanChoose).obs;
  double maxPrice = 5500;
  double minPrice = 0;
  RxList<bool> stars = [false, false, false, false, false].obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: Get.width / 4,
          child: const ClipOval(
            child: Divider(
              thickness: 5,
              color: Colors.black,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: Get.height / (count + 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Check-in Date',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text('Check-out Date',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FilledButton(
                            style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: pickDate,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.date_range,
                                  color: Colors.black,
                                ),
                                Text(start.value,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text(end.value,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                const Icon(
                                  Icons.date_range,
                                  color: Colors.black,
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height / (count + 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Adults :',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Text('Beds : ',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: 100,
                          child: TextField(
                            controller: adultController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[1-9]$'))
                            ],
                            decoration: const InputDecoration(
                                floatingLabelStyle: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                labelText: 'Adults',
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                          )),
                      SizedBox(
                          width: 100,
                          child: TextField(
                            controller: bedsController,
                            keyboardType:
                                const TextInputType.numberWithOptions(),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[1-5]$'))
                            ],
                            decoration: const InputDecoration(
                                floatingLabelStyle: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                labelText: 'Beds',
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height / (count + 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Sea View Only',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Obx(() => Switch(
                      value: seaView.value,
                      onChanged: setSeaView))
                ],
              ),
            ),
            SizedBox(
              height: Get.height / (count + 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Price Range',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Obx(() => RangeSlider(
                        inactiveColor: Colors.redAccent[100],
                        activeColor: Colors.redAccent,
                        divisions: 50,
                        labels: RangeLabels("${minPrice.round()}",
                            "${maxPrice.round()}"),
                        values: priceRange.value,
                        onChanged: changePriceRange,
                        max:maxPriceCanChoose,
                        min: minPriceCanChoose,
                      )),
                ],
              ),
            ),
            SizedBox(
                height: Get.height / (count + 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Rating',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getRatingWidget(0),
                        getRatingWidget(1),
                        getRatingWidget(2),
                        getRatingWidget(3),
                        getRatingWidget(4),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FilledButton(
                            onPressed: resetFilters,
                            style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            child: const Text('Reset'),
                          ),
                          FilledButton(
                            onPressed: applyFilters,
                            style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            child: const Text('Search'),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ],
        ),
      ],
    );
  }
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
    if (widget.panelController.isPanelOpen) {
      widget. panelController.close();
    }
    int beds = int.tryParse(bedsController.text) ?? 0;
    int adult = int.tryParse(adultController.text) ?? 0;
    var list = getRating();
    widget.searchOnClick({
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
  resetFilters() {
    seaView.value = false;
    priceRange.value = const RangeValues(minPriceCanChoose, maxPriceCanChoose);
    stars.value = [false, false, false, false, false];
    if (widget.panelController.isPanelOpen) {
      widget. panelController.close();
    }
    widget. resetOnClick();
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
