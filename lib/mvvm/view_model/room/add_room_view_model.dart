import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/mvvm/repository/room/room_api.dart';
import 'package:hotel_management/util/const.dart';
import 'package:image_picker/image_picker.dart';

class AddRoomViewModel {
  double rating = 3.5;
  XFile? image;
  RxBool seaView = false.obs;
  List<XFile>? slideShow;
  TextEditingController idController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController bedsController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
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
      String floor = idController.text;
      double price = double.parse(priceController.text);
      int beds = int.parse(bedsController.text);
      int size = int.parse(sizeController.text);
      bool validRoomId = roomApi.validateData(floor);
      if (!validRoomId) {
        Get.snackbar('Please enter a valid Room Floor',
            'a valid Floor is One Number Only');
      } else {
        String id = await roomApi.getNextID(floor);
        id = '$floor$id';
        Room room = Room(
            roomId: id,
            seaView: true,
            stars: rating,
            pictureUrl: await uploadImage(id),
            price: price,
            slideshow: [noImage, noImage],
            beds: beds,
            adults: size);
        await roomApi.saveRoom(room);
        print(room.toString());
        Get.snackbar('DONE', 'Room Added!');
        Get.offNamed('/home');
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

  void setSeaView(bool value) {
    seaView.value = !seaView.value;
  }
}
