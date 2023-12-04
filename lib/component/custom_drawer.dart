import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/ads/banner_ads.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/controller/login_controller.dart';
import 'package:hotel_management/model/user_model.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:hotel_management/view/request/requests_page_view.dart';
import 'package:hotel_management/view/room/add_room_view.dart';
import 'package:hotel_management/view/room/my_rooms_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel =  Get.find<UserModel>();
    return _getDrawer(
        userModel.profileImageUrl,
        '${userModel.firstName} ${userModel.lastName}',
        RoleUtil.fromString( userModel.role));
  }

  Widget _profile(String profileImageUrl, String fullName, ROLE role) {
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
                        profileImageUrl != ''
                    ? CachedNetworkImage(
                        imageUrl: profileImageUrl,
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
                fullName,
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
                role == ROLE.reception
                    ? 'reception'
                    : role == ROLE.admin
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

  Widget _getDrawer(String profileImageUrl, String fullName, ROLE role) {
    return Drawer(
        elevation: 10,
        width: (Get.width) * (3 / 4),
        child: Column(
          children: [
            _profile(profileImageUrl, fullName, role),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            _getNavTile(role),
            _getAddTile(role),
            _getMyRoomsTile(),
            ListTile(
              leading: const Icon(Icons.my_library_books_rounded),
              title: const Text('My Requests'),
              onTap: () async {
                var res = await Connectivity().checkConnectivity();
                if (res == ConnectivityResult.ethernet ||
                    res == ConnectivityResult.wifi ||
                    res == ConnectivityResult.mobile) {
                  Get.back();
                  Get.to(() => const RequestsPagesView(myRequests: true,));
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
              onTap: Get.find<LoginController>().signOut,
            ),
            kIsWeb?const SizedBox():const BannerAdWidget(
              withClose: false,
            ),
          ],
        ));
  }

  _getNavTile(ROLE role) => role == ROLE.customer
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
                          Navigator.pushReplacementNamed(Get.context!,'/recep_home');
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
                          Navigator.pushReplacementNamed(Get.context!,'/home');
                        },
                      ),
                    ],
                  ),
          ],
        );

  _getAddTile(ROLE role) => role == ROLE.admin && Get.currentRoute == '/home'
      ? Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Room'),
              onTap: () async {
                Get.to(() => const AddRoom());
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
