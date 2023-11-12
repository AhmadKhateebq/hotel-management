import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/view_model/room/add_room_view_model.dart';
import 'package:hotel_management/util/const.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final viewModel = AddRoomViewModel();

  @override
  void dispose() {
    viewModel.idController.dispose();
    viewModel.priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        minimum: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            centerTitle: true,
            title: const Text(
              'Add your details',
              style: TextStyle(fontSize: 24),
            ),
          ),
          body: Form(
              key: viewModel.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getImageButton(),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the room id';
                      }
                      return null;
                    },
                    controller: viewModel.idController,
                    decoration: const InputDecoration(
                        floatingLabelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        labelText: 'Room ID',
                        filled: true,
                        fillColor: Colors.white60,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                  TextFormField(
                    controller: viewModel.priceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    decoration: const InputDecoration(
                        floatingLabelStyle:
                            TextStyle(color: Colors.black, fontSize: 18),
                        labelText: 'Room Price',
                        filled: true,
                        fillColor: Colors.white60,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                  getRatingWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                          onPressed: viewModel.imagePickerSlideshow,
                          child: const Text('Pick Slideshow')),
                      FilledButton(
                          onPressed: viewModel.saveRoom,
                          child: const Text('save')),
                    ],
                  ),
                  Obx(() => setSlideShow()),
                ],
              )),
        ));
  }

  Widget setSlideShow() {
    if (!viewModel.slideshowPicked.value) {
      return ImageSlideshow(
        isLoop: true,
        autoPlayInterval: 5000,
        children: [Image.network(noImage)],
      );
    } else {
      List<Widget> images = [];
      for (var value in viewModel.slideShow!) {
        images.add(Image.file(File(value.path)));
      }
      return ImageSlideshow(
        isLoop: true,
        autoPlayInterval: 5000,
        children: images,
      );
    }
  }

  getImageButton() => FilledButton(
      style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      onPressed: viewModel.imagePicker,
      child: ClipRRect(
        child: !viewModel.imagePicked.value
            ? Image.network(
                noImage,
                width: Get.width,
                height: Get.height / 3,
              )
            : Image.file(
                File(viewModel.image!.path),
                width: Get.width,
                height: Get.height / 3,
                fit: BoxFit.cover,
              ),
      ));

  getRatingWidget() => RatingBar.builder(
        initialRating: viewModel.rating,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (r) {
          viewModel.rating = r;
        },
      );
}
