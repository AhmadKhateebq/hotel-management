import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/controller/database_controller.dart';
import 'package:hotel_management/controller/requests_controller.dart';
import 'package:hotel_management/pages/add_new_customer.dart';
import 'package:hotel_management/pages/add_room.dart';
import 'package:hotel_management/pages/login_screen.dart';
import 'package:hotel_management/pages/reciptionest_home.dart';
import 'package:hotel_management/pages/splash_screen.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/home_screen.dart';
const primaryColor = Colors.redAccent;
final secondaryColor = Colors.red.shade50;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: publicAnonKey,
  );
  Get.put(SupabaseDatabaseController());
  Get.put(RoomRequestController());
  Get.put(SupabaseAuthController());
  Get.put(UtilityClass());
  runApp(GetMaterialApp(
    color: primaryColor,
    theme: ThemeData(
      useMaterial3: true,
      cardColor: secondaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: secondaryColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor
        )
      ),
      switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(Colors.red),
          trackColor: MaterialStateProperty.resolveWith((states) =>
          states.contains(MaterialState.selected) ?primaryColor.shade100 : Colors.grey[350])),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(getColor),
      )
    ),
    getPages: [
      GetPage(
          name: '/',
          page: () => const HomeScreen(),
          transition: Transition.leftToRightWithFade),
      GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          transition: Transition.fadeIn),
      GetPage(
          name: '/home',
          page: () => const HomeScreen(),
          transition: Transition.leftToRight),
      GetPage(name: '/loading', page: () => const SplashScreen()),
      GetPage(
          name: '/recep_home',
          page: () => const ReceptionHome(),
          transition: Transition.downToUp),
      GetPage(name: '/add_customer', page: () => const AddCustomer()),
      GetPage(name: '/add_room', page: () => const AddRoom()),
    ],
    initialRoute: '/login',
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
