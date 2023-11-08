import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/requests_list_view.dart';
import 'package:hotel_management/component/scaffold_widget.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/controller/database_controller.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReceptionHome extends StatefulWidget {
  const ReceptionHome({super.key});

  @override
  State<ReceptionHome> createState() => _ReceptionHomeState();
}

class _ReceptionHomeState extends State<ReceptionHome>
    with TickerProviderStateMixin {
  bool pending = false;
  bool approved = false;
  bool intertwined = false;
  bool denied = false;
  late TabController _tabController;
  final SupabaseAuthController authController = Get.find();
  final SupabaseDatabaseController databaseController = Get.find();
  late final User user;
  late final String profileImageUrl;
  late final String fullName;
  late final ROLE role;

  @override
  void initState() {
    super.initState();
    getUserData();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScaffoldBuilder(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          title: const Text('Requests'),
          bottom: getTabBar(),
        ),
        body: RequestsListView(
          pending: pending,
          approved: approved,
          intertwined: intertwined,
          denied: denied,
        ),
        title: 'Requests',
        drawer: getDrawer(),
      ),
    );
  }

  getTabBar() => TabBar(
        controller: _tabController,
        tabs: const <Tab>[
          Tab(
            icon: Icon(Icons.home),
            text: 'All',
          ),
          Tab(
            icon: Icon(Icons.access_time_outlined),
            text: 'Pending',
          ),
          Tab(
            icon: Icon(Icons.check),
            text: 'Approved',
          ),
          Tab(
            icon: Icon(Icons.compare_arrows),
            text: 'intertwined',
          ),
          Tab(
            icon: Icon(Icons.close),
            text: 'Denied',
          ),
        ],
        onTap: _onTapItem,
      );

  _onTapItem(int index) => setState(() {
        if (index == 0) {
          pending = false;
          approved = false;
          intertwined = false;
          denied = false;
        }
        if (index == 1) {
          pending = true;
          approved = false;
          intertwined = false;
          denied = false;
        }
        if (index == 2) {
          pending = false;
          approved = true;
          intertwined = false;
          denied = false;
        }
        if (index == 3) {
          pending = false;
          approved = false;
          intertwined = true;
          denied = false;
        }
        if (index == 4) {
          pending = false;
          approved = false;
          intertwined = false;
          denied = true;
        }
      });

  signOut() async {
    await Get.find<SupabaseAuthController>().signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  getUserData() {
    user = authController.user!;
    profileImageUrl = user.userMetadata?['avatar_url'] != null
        ? user.userMetadata!['avatar_url']
        : databaseController.currentCustomerDetails.pictureUrl ??
            'https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG-Free-Download.png';
    fullName = user.userMetadata?['full_name'] != null
        ? user.userMetadata!['full_name']
        : '${databaseController.currentCustomerDetails.firstName} ${databaseController.currentCustomerDetails.lastName}';
    role = databaseController.currentCustomerRole;
  }

  Widget getDrawer() => Drawer(
      elevation: 10,
      width: (context.width) * (3 / 4),
      child: Column(
        children: [
          Container(
            color: background,
            height: (context.height) * (1 / 4),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ClipOval(
                      child: Image.network(
                        profileImageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      fullName,
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
                      role == ROLE.reception ? 'reception' : 'Admin',
                      style: const TextStyle(
                          fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("View Rooms"),
            onTap: () async {
              Get.offAllNamed('/home');
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text("logout"),
            onTap: () async {
              await authController.signOut();
              if (context.mounted) {
                Get.offAllNamed('/login');
              }
            },
          ),
        ],
      ));
}
