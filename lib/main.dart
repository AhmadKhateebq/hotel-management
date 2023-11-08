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
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: publicAnonKey,
  );
  Get.put(SupabaseDatabaseController());
  Get.put(RoomRequestController());
  Get.put(SupabaseAuthController());
  runApp( GetMaterialApp(
    getPages:[
      GetPage(name: '/', page: ()=>const HomeScreen(),transition: Transition.leftToRightWithFade),
      GetPage(name: '/login', page: ()=>const LoginScreen(),transition: Transition.fadeIn),
      GetPage(name: '/home', page: ()=>const HomeScreen(),transition: Transition.leftToRight),
      GetPage(name: '/loading', page: ()=>const SplashScreen()),
      GetPage(name: '/recep_home', page: ()=>const ReceptionHome(),transition: Transition.downToUp),
      GetPage(name: '/add_customer', page: ()=>const AddCustomer()),
      GetPage(name: '/add_room', page: ()=>const AddRoom()),
    ],
    initialRoute: '/login',
  ));
}
