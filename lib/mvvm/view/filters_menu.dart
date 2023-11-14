import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/view_model/filters_menu_model_view.dart';

class FiltersCustomMenu extends StatefulWidget {
  const FiltersCustomMenu({super.key, required this.viewModel});

  final FilterMenuModelView viewModel;
  final int count = 5;

  @override
  State<FiltersCustomMenu> createState() => _FiltersCustomMenuState();
}

class _FiltersCustomMenuState extends State<FiltersCustomMenu> {
  late final FilterMenuModelView viewModel;

  @override
  void initState() {
    viewModel = widget.viewModel;
    super.initState();
  }

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
              height: Get.height / (widget.count + 1),
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
                            onPressed: viewModel.pickDate,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.date_range,
                                  color: Colors.black,
                                ),
                                Text(viewModel.start.value,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text(viewModel.end.value,
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
              height: Get.height / (widget.count + 1),
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
                            controller: viewModel.adultController,
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
                            controller: viewModel.bedsController,
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
              height: Get.height / (widget.count + 1),
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
                      value: viewModel.seaView.value,
                      onChanged: viewModel.setSeaView))
                ],
              ),
            ),
            SizedBox(
              height: Get.height / (widget.count + 1),
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
                        labels: RangeLabels(
                            "${viewModel.minPrice}", "${viewModel.maxPrice}"),
                        values: viewModel.priceRange.value,
                        onChanged: viewModel.changePriceRange,
                        max: FilterMenuModelView.maxPriceCanChoose,
                        min: FilterMenuModelView.minPriceCanChoose,
                      )),
                ],
              ),
            ),
            SizedBox(
                height: Get.height / (widget.count + 1),
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
                        viewModel.getRatingWidget(0),
                        viewModel.getRatingWidget(1),
                        viewModel.getRatingWidget(2),
                        viewModel.getRatingWidget(3),
                        viewModel.getRatingWidget(4),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FilledButton(
                            onPressed: viewModel.resetFilters,
                            style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            child: const Text('Reset'),
                          ),
                          FilledButton(
                            onPressed: viewModel.applyFilters,
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
}
