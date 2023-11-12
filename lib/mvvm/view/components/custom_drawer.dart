import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer(
      {super.key,
      required this.profile,
      required this.navigationTile,
      this.onLogout});

  final Widget profile;
  final Widget navigationTile;
  final void Function()? onLogout;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Drawer(
        elevation: 10,
        width: (width) * (3 / 4),
        child: Column(
          children: [
            profile,
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            navigationTile,
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text("logout"),
              onTap: onLogout,
            ),
          ],
        ));
  }
}
