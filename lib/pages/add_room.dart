import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/scaffold_widget.dart';
import 'package:hotel_management/controller/database_controller.dart';
import 'package:hotel_management/model/room.dart';
import 'package:hotel_management/util/const.dart';
import 'package:image_picker/image_picker.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  double rating = 3.5;
  XFile? image;
  List<XFile>? slideShow;
  SupabaseDatabaseController controller = Get.find();
  TextEditingController idController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    idController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        minimum: EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: ScaffoldBuilder(
          body: Form(
              key: _formKey,
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
                    controller: idController,
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
                    controller: priceController,
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
                          onPressed: imagePickerSlideshow,
                          child: const Text('Pick Slideshow')),
                      FilledButton(
                          onPressed: saveRoom, child: const Text('save')),
                    ],
                  ),
                  setSlideShow(),
                ],
              )),
          title: 'Add a Room',
        ));
  }

  imagePicker() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  imagePickerSlideshow() async {
    slideShow = await ImagePicker().pickMultiImage();
    setState(() {});
  }

  saveRoom() async {
    if (_formKey.currentState!.validate()) {
      bool validId = false;
      String id = idController.text;

      double price = double.parse(priceController.text);
      RegExp myRegExp = RegExp(r"^[0-9]{1,2}[A-Z]{1,2}$");
      if (myRegExp.hasMatch(id)) {
        var match = myRegExp.matchAsPrefix(id)!;
        if (id.length == match.end) {
          validId = true;
        } else {
          Get.snackbar('Please enter a valid ID',
              'the valid id in your Field is ${id.substring(match.start, match.end)}');
        }
      } else {
        Get.snackbar('Please enter a valid ID',
            'the valid IDs are like [1A,1AA,11A,11AA]');
      }
      if (validId) {
        if (await controller.roomExists(id)) {
          Get.snackbar('A Room with this ID Exists',
              'there is a room with this id,please change the id');
        } else {
          Room room = Room(
              roomId: id,
              reserved: false,
              stars: rating,
              pictureUrl: noImage,
              price: price,
              slideshow: [noImage, noImage]);
          await controller.saveRoom(room);
          Get.snackbar('DONE', 'Room Added!');
          Get.offNamed('/home');
        }
      }
    }
  }

  uploadImage() {
    return noImage;
  }

  uploadSlideShow() {
    return [
      noImage,
      noImage,
      noImage,
    ];
  }

  Widget setSlideShow() {
    if (slideShow == null || slideShow!.isEmpty) {
      return ImageSlideshow(
        isLoop: true,
        autoPlayInterval: 5000,
        children: [Image.network(noImage)],
      );
    }
    List<Widget> images = [];
    for (var value in slideShow!) {
      images.add(Image.file(File(value.path)));
    }
    return ImageSlideshow(
      isLoop: true,
      autoPlayInterval: 5000,
      children: images,
    );
  }

  getImageButton() => FilledButton(
      style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
      onPressed: imagePicker,
      child: ClipRRect(
        child: image == null
            ? Image.network(
                noImage,
                width: Get.width,
                height: Get.height / 3,
              )
            : Image.file(
                File(image!.path),
                width: Get.width,
                height: Get.height / 3,
                fit: BoxFit.cover,
              ),
      ));

  getRatingWidget() => RatingBar.builder(
        initialRating: rating,
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
          rating = r;
          print(r);
        },
      );
}
