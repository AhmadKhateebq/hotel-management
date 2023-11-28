import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/repository/customer/customer_api.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:image_picker/image_picker.dart';

class AddNewCustomerViewModel {
  late DateTime dateOfBirth;


  final CustomerApi customerApi = Get.find();
  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final dateController = TextEditingController();
  var imagePicked = false.obs;
  XFile? _image;
  String? _imageUrl;

  String get imageUrl => _imageUrl ?? noImage;

  String get imagePath => _image!.path;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  pickDate() async {
    dateOfBirth = (await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          initialDatePickerMode: DatePickerMode.year,
        )) ??
        DateTime.now();
    dateController.text = DateFormatter.format(dateOfBirth);
  }

  void setArguments(arguments) {
    if (Get.arguments['firstName'] != null) {
      firstNameController.text = Get.arguments['firstName'];
    }
    if (Get.arguments['lastName'] != null) {
      lastNameController.text = Get.arguments['lastName'];
    }
    if (Get.arguments['imageUrl'] != null) {
      imageUrl = Get.arguments['imageUrl'];
    }
  }

  imagePicker() async {
    _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    imagePicked.value = false;
    imagePicked.value = true;
  }

  save() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    DateTime dateOfBirth = DateFormatter.parse(dateController.text);
    await customerApi.saveCustomer(
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        imageUrl: imageUrl);
    Get.back();
  }

  skip() async {

  }
}
