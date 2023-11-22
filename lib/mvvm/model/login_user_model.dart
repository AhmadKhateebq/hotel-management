import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/mvvm/model/customer_details.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_repository.dart';
import 'package:hotel_management/mvvm/view/requests/my_requests.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../view/components/ads/banner_ads.dart';

class LoginUser {
  late CustomerDetails currentCustomerDetails;
  User? user;
  String? _profileImageUrl;
  String? _fullName;
  ROLE? _role;
  bool _isInit = false;
  late final CustomerRepository customerApi;

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

  init() {
    if (!_isInit) {
      customerApi = Get.find();
      _isInit = true;
    }
  }

  Widget _profile() {
    init();
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
                () => Get.find<ConnectivityController>().connected.value && _profileImageUrl != ''
                    ? Image.network(
                        _profileImageUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/image/noImage.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              )),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                _fullName!,
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
                _role == ROLE.reception
                    ? 'reception'
                    : _role == ROLE.admin
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
            getNavTile(),
            getAddTile(),
            getMyRoomsTile(),
            ListTile(
              leading: const Icon(Icons.my_library_books_rounded),
              title: const Text('My Requests'),
              onTap: () async {
                if(Get.find<ConnectivityController>().connected.value){
                  Get.to(() => const MyRequests());
                }
                else{
                  Get.snackbar('No Internet Connection', 'try again later');
                }
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.my_library_books_rounded),
            //   title: const Text('Parallax Test'),
            //   onTap: () async {
            //     Get.to(() => ParallaxRecipe(list: [
            //           ParallaxContainer(
            //               imageUrl: noImage, title: '', subtitle: ''),
            //           ParallaxContainer(
            //               imageUrl: noImage,
            //               title: 'title 2',
            //               subtitle: 'subtitle 2'),
            //           ParallaxContainer(
            //               imageUrl: noImage,
            //               title: 'title 3',
            //               subtitle: 'subtitle 3'),
            //           ParallaxContainer(
            //               imageUrl: noImage,
            //               title: 'title 4',
            //               subtitle: 'subtitle 4'),
            //           ParallaxContainer(
            //               imageUrl: noImage,
            //               title: 'title 5',
            //               subtitle: 'subtitle 5'),
            //           ParallaxContainer(
            //               imageUrl: noImage,
            //               title: 'title 6',
            //               subtitle: 'subtitle 6'),
            //         ]));
            //   },
            // ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text("logout"),
              onTap: customerApi.signOut,
            ),
            const BannerAdWidget(
              withClose: false,
            ),
          ],
        ));
  }

  getNavTile() => _role == ROLE.customer
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

  getAddTile() => _role == ROLE.admin && Get.currentRoute == '/home'
      ? Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Room'),
              onTap: () async {
                Get.offAllNamed('/add_room');
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

  getMyRoomsTile() => ListTile(
        leading: const Icon(Icons.history),
        title: const Text('My Rooms'),
        onTap: () async {
          Get.toNamed('/my_rooms');
        },
      );
}
