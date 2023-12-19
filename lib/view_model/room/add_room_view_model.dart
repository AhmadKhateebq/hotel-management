

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/model/room/add_room_model.dart';
import 'package:hotel_management/model/room/room_model.dart';
import 'package:hotel_management/util/const.dart';
import 'package:image_picker/image_picker.dart';

class AddRoomViewModel {
  final RoomModel _roomModel = Get.find();
  final AddRoomModel _model = AddRoomModel();
  TextEditingController idController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController bedsController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var imagePicked = false.obs;
  var slideshowPicked = false.obs;

  RxBool get seaView => _model.seaView;

  List<XFile>? get slideShow => _model.slideShow;
  XFile? get image => _model.image;

  double get rating => _model.rating;

  set rating(double value) {
    _model.setRating(value);
  }

  imagePicker() async {
   await _model.pickImage();
    imagePicked.value = true;
  }

  imagePickerSlideshow() async {
    await _model.pickSlideShow();
    slideshowPicked.value = true;
  }

  saveRoom() async {
    if (formKey.currentState!.validate()) {
      String floor = idController.text;
      double price = double.parse(priceController.text);
      int beds = int.parse(bedsController.text);
      int size = int.parse(sizeController.text);
      bool validRoomId = await _roomModel.validateData(floor);
      if (!validRoomId) {
        Get.snackbar('Please enter a valid Room Floor',
            'a valid Floor is One Number Only');
      } else {
        await _roomModel.saveRoom(floor, _model.rating, _model.image, price, beds, size);
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
   _model.setSeaView();
  }

}
