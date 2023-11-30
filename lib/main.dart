import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/view/request/requests_page_view.dart';
import 'package:hotel_management/view/splash_screen.dart';

import 'view/room/home_screen.dart';

final primaryColor = Colors.primaries[3];
bool internet = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      GetPage(name: '/splash', page: () => const SplashScreen()),
      GetPage(name: '/recep_home', page: () => const RequestsPagesView()),

    ],
    home: const SplashScreen(),
    initialRoute: '/splash',
    unknownRoute: GetPage( name: SplashScreen.routeName, page: () => const SplashScreen(), ),
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
    return primaryColor;
  }
  return Colors.white;
}
