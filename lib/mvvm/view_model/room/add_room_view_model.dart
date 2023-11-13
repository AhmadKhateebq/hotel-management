import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/mvvm/repository/room/room_api.dart';
import 'package:hotel_management/util/const.dart';
import 'package:image_picker/image_picker.dart';

class AddRoomViewModel{
  double rating = 3.5;
  XFile? image;
  List<XFile>? slideShow;
  TextEditingController idController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final roomApi = RoomApi();
  var imagePicked = false.obs;
  var slideshowPicked = false.obs;
  imagePicker() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    imagePicked.value = true;
  }

  imagePickerSlideshow() async {
    slideShow = await ImagePicker().pickMultiImage();
    slideshowPicked.value = true;
  }

  saveRoom() async {
    if (formKey.currentState!.validate()) {
      String id = idController.text;
      double price = double.parse(priceController.text);
      bool validRoomId = roomApi.validateData(id);
      if (!validRoomId) {
        Get.snackbar('Please enter a valid ID',
            'the valid IDs are like [1A,1AA,11A,11AA]');
      } else {
        if (await roomApi.roomExists(id)) {
          Get.snackbar('A Room with this ID Exists',
              'there is a room with this id,please change the id');
        } else {
          Room room = Room(
              roomId: id,
              seaView: false,
              stars: rating,
              pictureUrl: await uploadImage(id),
              price: price,
              slideshow: [noImage, noImage], beds: 1, adults: 1);
          await roomApi.saveRoom(room);
          Get.snackbar('DONE', 'Room Added!');
          Get.offNamed('/home');
        }
      }
    }
  }

  uploadImage(String roomId) async {
    return image != null
        ? await roomApi.uploadImage(File(image!.path), roomId)
        : noImage;
  }

  uploadSlideShow() {
    return [
      noImage,
      noImage,
      noImage,
    ];
  }
}