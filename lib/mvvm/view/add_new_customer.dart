import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/view_model/add_new_customer_view_model.dart';

class AddCustomer extends StatelessWidget {
  const AddCustomer({super.key, required this.viewModel});

  final AddNewCustomerViewModel viewModel ;

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      viewModel.setArguments(Get.arguments);
    }
    return SafeArea(
        child: Scaffold(
            body: getForm(),
            appBar: AppBar(
              titleSpacing: 0,
              centerTitle: true,
              title: const Text(
                'Add your details',
                style: TextStyle(fontSize: 24),
              ),
            )));
  }

  getForm() => Form(
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
                onPressed: viewModel.imagePicker,
                child: ClipOval(
                  child: Obx(() => viewModel.imagePicked.value == false
                      ? Image.network(
                          viewModel.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(viewModel.imagePath),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )),
                )),
            TextFormField(
              controller: viewModel.firstNameController,
              decoration: const InputDecoration(
                  floatingLabelStyle:
                      TextStyle(color: Colors.black, fontSize: 18),
                  labelText: 'First Name',
                  filled: true,
                  fillColor: Colors.white60,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: viewModel.lastNameController,
              decoration: const InputDecoration(
                  floatingLabelStyle:
                      TextStyle(color: Colors.black, fontSize: 18),
                  labelText: 'Last Name',
                  filled: true,
                  fillColor: Colors.white60,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: viewModel.dateController,
              readOnly: true,
              onTap: viewModel.pickDate,
              decoration: InputDecoration(
                  floatingLabelStyle:
                      const TextStyle(color: Colors.black, fontSize: 18),
                  labelText: 'Date of birth',
                  filled: true,
                  suffixIcon: IconButton(
                      onPressed: viewModel.pickDate,
                      icon: const Icon(Icons.date_range)),
                  fillColor: Colors.white60,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                    onPressed: viewModel.skip, child: const Text('skip')),
                FilledButton(
                    onPressed: viewModel.save, child: const Text('save'))
              ],
            )
          ],
        ),
      ),
    );
}
