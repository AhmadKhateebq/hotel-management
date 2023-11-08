import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotel_management/pages/component/rooms_list_view.dart';
import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UtilityClass util = Get.find();
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

  @override
  void initState() {
    util.getUserData();
    bedsController.text = '$beds';
    adultController.text = '$adults';
    priceRange = RangeValues(minPriceCanChoose, maxPriceCanChoose);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: homeScreen(),
          appBar: AppBar(
            title: const Text(
              'Available Rooms',
              style: TextStyle(fontSize: 24),
            ),
            titleSpacing: 0,
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: openFilters, icon: const Icon(Icons.filter_alt)),
            ],
          ),
          drawer: util.getDrawer(),
          floatingActionButton: util.addRoom()),
    );
  }

  homeScreen() {
    return Stack(children: [
      Center(
        child: RoomsListView(
          startDate: startDate,
          endDate: endDate,
        ),
      ),
      SlidingUpPanel(
        controller: panelController,
        panel: getSlidingUpPanel(5),
        minHeight: 0,
        maxHeight: Get.height,
      ),
    ]);
  }



  openFilters() {
    panelController.isPanelOpen
        ? panelController.close()
        : panelController.open();
  }

  Widget getSlidingUpPanel(int count) {
    count += 1;
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
              height: Get.height / count,
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
                            onPressed: () async {
                              var a = await util.dateRangePicker();
                              if (a != null) {
                                setState(() {
                                  startDate = a.start;
                                  endDate = a.end;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Icon(
                                    Icons.date_range,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(DateFormatter.format(startDate),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ],
                            )),
                      ),
                      Expanded(
                        child: FilledButton(
                            style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () async {
                              var a = await showDateRangePicker(
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 1461)),
                                  context: context);
                              if (a != null) {
                                setState(() {
                                  startDate = a.start;
                                  endDate = a.end;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.date_range,
                                  color: Colors.black,
                                ),
                                Text(DateFormatter.format(endDate),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ],
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height / count,
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
              height: Get.height / count,
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
                  Switch(
                      value: seaView,
                      onChanged: (val) {
                        setState(() {
                          seaView = val;
                        });
                      })
                ],
              ),
            ),
            SizedBox(
              height: Get.height / count,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'Price Range',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              priceRange = RangeValues(
                                  minPriceCanChoose, maxPriceCanChoose);
                            });
                          },
                          icon: const Icon(Icons.refresh, size: 20))
                    ],
                  ),
                  RangeSlider(
                    inactiveColor: Colors.redAccent[100],
                    activeColor: Colors.redAccent,
                    divisions: 50,
                    labels: RangeLabels(
                        priceRange.start.toString(), priceRange.end.toString()),
                    values: priceRange,
                    onChanged: (value) {
                      setState(() {
                        double start = value.start;
                        double end = value.end;
                        if (start > end) {
                          end = start;
                        }
                        priceRange = RangeValues(start, end);
                      });
                    },
                    max: maxPriceCanChoose,
                    min: minPriceCanChoose,
                  ),
                ],
              ),
            ),
            SizedBox(
                height: Get.height / count,
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
                      child: FilledButton(
                        onPressed: applyFilters,
                        style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: const Text('Search'),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ],
    );
  }

  getRatingWidget(int no) => Column(
        children: [
          Text('${no + 1} star'),
          Checkbox(
              value: stars[no],
              onChanged: (val) {
                setState(() {
                  stars[no] = val!;
                });
              })
        ],
      );

  applyFilters() {
    adults = int.parse(adultController.text);
    beds = int.parse(bedsController.text);
    log('1 star', name: '${stars[0]}');
    log('2 star', name: '${stars[1]}');
    log('3 star', name: '${stars[2]}');
    log('4 star', name: '${stars[3]}');
    log('5 star', name: '${stars[4]}');
    log('adults', name: '$adults');
    log('max price', name: '${priceRange.end}');
    log('min price', name: '${priceRange.start}');
    log('beds', name: '$beds');
    log('rating', name: '$rating');
    log('start date', name: DateFormatter.format(startDate));
    log('end date', name: DateFormatter.format(endDate));

    panelController.isPanelOpen ? panelController.close() : null;
  }
}
