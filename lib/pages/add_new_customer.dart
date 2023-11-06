import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/scaffold_widget.dart';
import 'package:hotel_management/controller/database_controller.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:image_picker/image_picker.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final dateController = TextEditingController();

  late DateTime dateOfBirth;

  XFile? image;
  String? imageUrl;

  var imagePicked = false.obs;

  @override
  void initState() {
    if (Get.arguments != null) {
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: ScaffoldBuilder(body: getForm(), title: 'Add your details', floatingChild: null, onPressed: null));
  }
  getForm(){
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                onPressed: imagePicker,
                child: ClipOval(
                  child: Obx(() => imagePicked.value == false
                      ? Image.network(
                    imageUrl ?? noImage,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                      : Image.file(
                    File(image!.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )),
                )),
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(
                  floatingLabelStyle:
                  TextStyle(color: Colors.black, fontSize: 18),
                  labelText: 'First Name',
                  filled: true,
                  fillColor: Colors.white60,
                  border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(
                  floatingLabelStyle:
                  TextStyle(color: Colors.black, fontSize: 18),
                  labelText: 'Last Name',
                  filled: true,
                  fillColor: Colors.white60,
                  border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: dateController,
              readOnly: true,
              onTap: pickDate,
              decoration: InputDecoration(
                  floatingLabelStyle:
                  const TextStyle(color: Colors.black, fontSize: 18),
                  labelText: 'Date of birth',
                  filled: true,
                  suffixIcon: IconButton(
                      onPressed: pickDate,
                      icon: const Icon(Icons.date_range)),
                  fillColor: Colors.white60,
                  border: const OutlineInputBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.0)))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(onPressed: skip, child: const Text('skip')),
                FilledButton(onPressed: save, child: const Text('save'))
              ],
            )
          ],
        ),
      ),
    );
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

  imagePicker() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    imagePicked.value = false;

    imagePicked.value = true;
  }

  save() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    DateTime dateOfBirth = DateFormatter.parse(dateController.text);
    print(dateOfBirth.toString());
    print(imageUrl);
    await Get.find<SupabaseDatabaseController>().save(
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        imageUrl: imageUrl);
    Get.back();
  }

  skip() async {
    await Get.find<SupabaseDatabaseController>()
        .save(firstName: 'john', lastName: 'doe', dateOfBirth: DateTime.now());
    Get.back();
  }
}
