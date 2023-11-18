import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/mvvm/repository/request/requests_api.dart';
import 'package:hotel_management/mvvm/view/add_new_customer.dart';
import 'package:hotel_management/mvvm/view/first_screen.dart';
import 'package:hotel_management/mvvm/view/login_screen.dart';
import 'package:hotel_management/mvvm/view/reciptionest_home.dart';
import 'package:hotel_management/mvvm/view/requests/my_requests.dart';
import 'package:hotel_management/mvvm/view/room/add_room.dart';
import 'package:hotel_management/mvvm/view/room/my_rooms.dart';
import 'package:hotel_management/mvvm/view/splash_screen.dart';
import 'package:hotel_management/mvvm/view_model/add_new_customer_view_model.dart';
import 'package:hotel_management/mvvm/view_model/splash_screen_model_view.dart';

import 'mvvm/view/home_screen.dart';

const primaryColor = Colors.redAccent;
final secondaryColor = Colors.red.shade50;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: publicAnonKey,
  );
  Get.put(RoomRequestApi());
  Get.put(SupabaseAuthController());
  // Get.put(FirebaseAnalyticsController());
  runApp(GetMaterialApp(
    color: primaryColor,
    theme: ThemeData(
        fontFamily: 'RobotoCondensed',
        useMaterial3: true,
        cardColor: secondaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: secondaryColor,
        ),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(backgroundColor: primaryColor),
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
      GetPage(
          name: '/loading',
          page: () => SplashScreen(
                modelView: SplashScreenModelView(),
              )),
      GetPage(
          name: '/recep_home',
          page: () => const ReceptionHome(),
          transition: Transition.downToUp),
      GetPage(
          name: '/add_customer',
          page: () => AddCustomer(
                viewModel: AddNewCustomerViewModel(),
              )),
      GetPage(name: '/add_room', page: () => const AddRoom()),
      GetPage(name: '/my_rooms', page: () => const MyRoomsView()),
      GetPage(name: '/my_request', page: () => const MyRequests()),
      GetPage(name: '/first', page: () => const FirstScreen()),
    ],
    initialRoute: '/first',
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
