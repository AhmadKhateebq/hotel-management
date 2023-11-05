import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/date_formatter_util.dart';

Color background = Colors.redAccent;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return homeScreen(context);
  }
}

homeScreen(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 0,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: background,
        title: const Text(
          'hotel management',
          style: TextStyle(fontSize: 24),
        ),
      ),
      drawer: Drawer(
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
                          child: Image.network(
                            noImage,
                            width: 100,
                          )),
                      const Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          "menu",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
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
                leading: const Icon(Icons.info),
                title: const Text("more"),
                onTap: () async {
                  String now = DateFormatter.formatWithTime(DateTime.now());
                  print(now);
                  print(DateFormatter.parse(now));
                  print(DateFormatter.parseWithTime(now));
                  print(DateTime.now());
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text("logout"),
                onTap: () async {},
              ),
            ],
          )),
      body: const Center(
        child: Text('Hotel'),
      ),
      floatingActionButton: FloatingActionButton(
        // title: Text("add".tr),
        backgroundColor: background,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () async {},
      ),
    ),
  );
}
