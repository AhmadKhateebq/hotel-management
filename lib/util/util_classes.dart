import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/controller/database_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum ROLE {
  customer,
  admin,
  reception,
}

enum STATUS { pending, approved, denied, reserved }

class Role {
  static const customer = ROLE.customer;
  static const admin = ROLE.admin;
  static const resp = ROLE.reception;

  static ROLE fromString(String str) {
    if (str == 'customer') {
      return customer;
    } else if (str == 'admin') {
      return admin;
    } else if (str == 'reception') {
      return resp;
    } else {
      return customer;
    }
  }

  static String roleToString(ROLE role) {
    if (role == ROLE.customer) {
      return 'customer';
    } else if (role == ROLE.admin) {
      return 'admin';
    } else if (role == ROLE.reception) {
      return 'reception';
    } else {
      return 'customer';
    }
  }
}

class UtilityClass extends GetxController {
  User? _user;
  String? _profileImageUrl;
  String? _fullName;
  ROLE? _role;
  final SupabaseAuthController authController = Get.find();
  final SupabaseDatabaseController databaseController = Get.find();

  get customerId => _user!.id;

  getUserData() {
    if (_user != null) {
      return;
    }
    _user = authController.user!;
    _profileImageUrl = _user!.userMetadata?['avatar_url'] != null
        ? _user!.userMetadata!['avatar_url']
        : databaseController.currentCustomerDetails.pictureUrl ??
            'https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG-Free-Download.png';
    _fullName = _user!.userMetadata?['full_name'] != null
        ? _user!.userMetadata!['full_name']
        : '${databaseController.currentCustomerDetails.firstName} ${databaseController.currentCustomerDetails.lastName}';
    _role = databaseController.currentCustomerRole;
  }

  Widget profile() => SizedBox(
        height: (Get.height) * (1 / 4),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: ClipOval(
                  child: Image.network(
                    _profileImageUrl!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  _fullName!,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  _role == ROLE.reception ? 'reception' : _role == ROLE.admin ? 'Admin' :'Customer',
                  style: const TextStyle(
                      fontSize: 15, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      );

  Widget addRoom() => (_role == ROLE.admin)
      ? FloatingActionButton(
          // title: Text("add".tr),
          onPressed: floatingActionOnClick,
          child: const Icon(Icons.add, color: Colors.black),
        )
      : const SizedBox();

  Widget getDrawer() {
    return Drawer(
        elevation: 10,
        width: (Get.width) * (3 / 4),
        child: Column(
          children: [
            profile(),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            getNavTile(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text("logout"),
              onTap: logout,
            ),
          ],
        ));
  }

  getNavTile() => _role == ROLE.customer
      ? const SizedBox()
      : Get.currentRoute == '/home'
          ? ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('To Requests'),
              onTap: () async {
                Get.offAllNamed('/recep_home');
              },
            )
          : ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('To Rooms'),
              onTap: () async {
                Get.offAllNamed('/home');
              },
            );

  floatingActionOnClick() async {
    Get.toNamed('/add_room');
  }

  logout() async {
    await authController.signOut();
    _user = null;
    _fullName = null;
    _profileImageUrl = null;
    _role = null;
    if (Get.context!.mounted) {
      Get.offAllNamed('/login');
    }
  }

  dateRangePicker() async {
    return await showDateRangePicker(
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 1461)),
        context: Get.context!);
  }
}
