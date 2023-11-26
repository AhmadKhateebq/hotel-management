import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_api.dart';
import 'package:hotel_management/mvvm/view/requests/reciptionest_home.dart';
import 'package:hotel_management/mvvm/view/splash_screen.dart';

import 'mvvm/view/room/home_screen.dart';

final primaryColor = Colors.primaries[3];
bool internet = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController.init();
  Get.put(ConnectivityController(), permanent: true);
  Get.put(CustomerApi(), permanent: true);
  await Get.find<ConnectivityController>().init();
  runApp(GetMaterialApp(
    color: primaryColor,
    theme: ThemeData(
        fontFamily: 'RobotoCondensed',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: primaryColor),
        filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(backgroundColor: primaryColor)),
        switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.all(Colors.red),
            trackColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? primaryColor.shade100
                    : Colors.grey[350])),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateColor.resolveWith(getColor),
        )),
    defaultTransition: Transition.cupertino,
    transitionDuration: const Duration(milliseconds: 500),
    getPages: [
      GetPage(name: '/home', page: () => const HomeScreen()),
      GetPage(name: '/recep_home', page: () => const ReceptionHome()),
    ],
    home: const SplashScreen(),
  ));
}

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
    MaterialState.selected,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.redAccent;
  }
  return Colors.white;
}
