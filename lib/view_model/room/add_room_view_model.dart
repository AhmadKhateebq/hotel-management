

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/model/room_model.dart';
import 'package:hotel_management/util/const.dart';
import 'package:image_picker/image_picker.dart';

class AddRoomViewModel {
  final RoomModel roomModel = Get.find();
  double rating = 3.5;
  XFile? image;
  RxBool seaView = false.obs;
  List<XFile>? slideShow;
  TextEditingController idController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController bedsController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
      bool validRoomId = await roomModel.validateData(floor);
      if (!validRoomId) {
        Get.snackbar('Please enter a valid Room Floor',
            'a valid Floor is One Number Only');
      } else {
        await roomModel.saveRoom(floor, rating, image, price, beds, size);
        Get.back();
        Get.snackbar('DONE', 'Room Added!');

      }
    }
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
