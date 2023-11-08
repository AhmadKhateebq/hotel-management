import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/rooms_list_view.dart';
import 'package:hotel_management/component/scaffold_widget.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/controller/database_controller.dart';
import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Color background = Colors.redAccent;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseAuthController authController = Get.find();
  final SupabaseDatabaseController databaseController = Get.find();
  late final User user;
  late final String profileImageUrl;
  late final String fullName;
  late final ROLE role;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ScaffoldBuilder(
            body: homeScreen(),
            title: 'Available Rooms ',
            drawer: getDrawer(),
          floatingActionButton: getFloatingActionButton(),
    ));
  }

  homeScreen() {
    return Center(
      child: RoomsListView(
        startDate: databaseController.start,
        endDate: databaseController.end,
      ),
    );
  }

  getDrawer() {
    return Drawer(
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
                        'From ${DateFormatter.format(databaseController.start)} To ${DateFormatter.format(databaseController.end)}',
                        style: const TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        role == ROLE.customer
                            ? 'Customer'
                            : role == ROLE.reception
                                ? 'Reception'
                                : 'Admin',
                        style: const TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic),
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
              leading: const Icon(Icons.date_range),
              title: const Text("select dates"),
              onTap: () async {
                Future.delayed(const Duration(seconds: 1));
                await pickDates();
                setState(() {});
              },
            ),
            databaseController.currentCustomerRole == ROLE.customer
                ? const SizedBox()
                : ListTile(
                    leading: const Icon(Icons.request_page),
                    title: const Text('To Requests'),
                    onTap: () async {
                      Get.offAllNamed('/recep_home');
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

  Widget getFloatingActionButton() {
    return (role == ROLE.admin)
        ? FloatingActionButton(
            // title: Text("add".tr),
            backgroundColor: background,
            onPressed: floatingActionOnClick,
            child: const Icon(Icons.add, color: Colors.black),
          )
        : const SizedBox();
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

  floatingActionOnClick() async {
    Get.toNamed('/add_room');
    print('add room pressed on ${role.toString()}');
  }

  Future<DateTime> pickDate({DateTime? startingDate}) async {
    return (await showDatePicker(
          helpText: startingDate == null
              ? "Chose a starting date"
              : "Chose an Ending date",
          context: Get.context!,
          initialDate: startingDate ?? DateTime.now(),
          firstDate: startingDate ?? DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          initialDatePickerMode: DatePickerMode.year,
        )) ??
        DateTime.now();
  }

  pickDates() async {
    databaseController.start = await pickDate();
    databaseController.end =
        await pickDate(startingDate: databaseController.start);
  }
}
