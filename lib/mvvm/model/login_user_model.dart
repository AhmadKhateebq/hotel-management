import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/mvvm/model/customer_details.dart';
import 'package:hotel_management/mvvm/view/requests/my_requests.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginUser {
  late CustomerDetails currentCustomerDetails;
  User? user;
  String? _profileImageUrl;
  String? _fullName;
  ROLE? _role;

  set profileImageUrl(String value) {
    _profileImageUrl = value;
  }

  String get profileImageUrl => _profileImageUrl ?? "";

  String get fullName => _fullName ?? "John Doe";

  ROLE get role => _role ?? ROLE.customer;

  logout() async {
    user = null;
    _fullName = null;
    _profileImageUrl = null;
    _role = null;
  }

  set fullName(String value) {
    _fullName = value;
  }

  set role(ROLE value) {
    _role = value;
  }

  Widget _profile() => SizedBox(
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
                  _role == ROLE.reception
                      ? 'reception'
                      : _role == ROLE.admin
                          ? 'Admin'
                          : 'Customer',
                  style: const TextStyle(
                      fontSize: 15, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      );

  Widget getDrawer() {
    return Drawer(
        elevation: 10,
        width: (Get.width) * (3 / 4),
        child: Column(
          children: [
            _profile(),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            getAddTile(),
            getNavTile(),
            getMyRoomsTile(),
            ListTile(
              leading: const Icon(Icons.my_library_books_rounded),
              title: const Text('To My Requests'),
              onTap: () async {
                Get.to(() => const MyRequests());
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text("logout"),
              onTap: Get.find<SupabaseAuthController>().signOut,
            ),
          ],
        ));
  }

  getNavTile() => _role == ROLE.customer
      ? const SizedBox()
      : Column(
          children: [
            Get.currentRoute == '/home'
                ? ListTile(
                    leading: const Icon(Icons.request_page),
                    title: const Text('To Requests'),
                    onTap: () async {
                      Get.offAllNamed('/recep_home');
                    },
                  )
                : Column(
                  children: [
                    const Text('Admin Menu'),
                    ListTile(
                        leading: const Icon(Icons.request_page),
                        title: const Text('To Rooms'),
                        onTap: () async {
                          Get.offAllNamed('/home');
                        },
                      ),
                  ],
                ),
            const Divider(
              thickness: 1,
            ),
          ],
        );

  getAddTile() => _role == ROLE.admin && Get.currentRoute == '/home'
      ? Column(
        children: [const Text('Admin Menu'),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Room'),
            onTap: () async {
              Get.offAllNamed('/add_room');
            },
          ),
        ],
      )
      : const SizedBox();

  getMyRoomsTile() => ListTile(
        leading: const Icon(Icons.history),
        title: const Text('My Rooms'),
        onTap: () async {
          Get.toNamed('/my_rooms');
        },
      );
}
