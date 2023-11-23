import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/mvvm/model/login_user_model.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_repository.dart';
import 'package:hotel_management/mvvm/view/requests/my_requests.dart';
import 'package:hotel_management/mvvm/view/room/add_room.dart';
import 'package:hotel_management/mvvm/view/room/my_rooms.dart';
import 'package:hotel_management/util/util_classes.dart';

import 'ads/banner_ads.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.user});

  final LoginUser user;

  @override
  Widget build(BuildContext context) {
    return _getDrawer();
  }

  Widget _profile() {
    return SizedBox(
      height: (Get.height) * (1 / 4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: ClipOval(
                  child: Obx(
                () => Get.find<ConnectivityController>().connected.value &&
                        user.profileImageUrl != ''
                    ? CachedNetworkImage(
                        imageUrl: user.profileImageUrl,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                        placeholder: (_, u) => Image.asset(
                          'assets/image/noProfile.png',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                        errorWidget: (context, url, error) => ClipOval(
                          child: Image.asset(
                            'assets/image/noProfile.png',
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      )
                    : ClipOval(
                        child: Image.asset(
                          'assets/image/noProfile.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
              )),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                user.fullName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                user.role == ROLE.reception
                    ? 'reception'
                    : user.role == ROLE.admin
                        ? 'Admin'
                        : 'Customer',
                style:
                    const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getDrawer() {
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
            _getNavTile(),
            _getAddTile(),
            _getMyRoomsTile(),
            ListTile(
              leading: const Icon(Icons.my_library_books_rounded),
              title: const Text('My Requests'),
              onTap: () async {
                if (Get.find<ConnectivityController>().connected.value) {
                  Get.back();
                  Get.to(() => const MyRequests());
                } else {
                  Get.snackbar('No Internet Connection', 'try again later');
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text("logout"),
              onTap: Get.find<CustomerRepository>().signOut,
            ),
            const BannerAdWidget(
              withClose: false,
            ),
          ],
        ));
  }

  _getNavTile() => user.role == ROLE.customer
      ? const SizedBox()
      : Column(
          children: [
            Get.currentRoute == '/home'
                ? Column(
                    children: [
                      const Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text('Admin Menu')),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: const Icon(Icons.request_page),
                        title: const Text('Requests'),
                        onTap: () async {
                          Get.offAllNamed('/recep_home');
                        },
                      ),
                    ],
                  )
                : Column(
                    children: [
                      const Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Text('Admin Menu')),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: const Icon(Icons.hotel),
                        title: const Text('Rooms'),
                        onTap: () async {
                          Get.offAllNamed('/home');
                        },
                      ),
                    ],
                  ),
          ],
        );

  _getAddTile() => user.role == ROLE.admin && Get.currentRoute == '/home'
      ? Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Room'),
              onTap: () async {
                Get.offAll(() => const AddRoom());
              },
            ),
            const Divider(
              thickness: 1,
            ),
          ],
        )
      : const Divider(
          thickness: 1,
        );

  _getMyRoomsTile() => ListTile(
        leading: const Icon(Icons.history),
        title: const Text('My Rooms'),
        onTap: () async {
          Get.back();
          Get.to(() => const MyRoomsView());
        },
      );
}
