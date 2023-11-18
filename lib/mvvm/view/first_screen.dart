import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/view/login_screen.dart';
import 'package:hotel_management/mvvm/view/splash_screen.dart';
import 'package:hotel_management/mvvm/view_model/first_screen_view_model.dart';
import 'package:hotel_management/mvvm/view_model/splash_screen_model_view.dart';

import '../../controller/app_lifecycle_reactor.dart';
import '../../controller/google_adds_controller.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final FirstScreenViewModel viewModel = FirstScreenViewModel();
  @override
  void initState() {

    viewModel.init();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant FirstScreen oldWidget) {
    viewModel.init();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => viewModel.isLoading.value
        ? SplashScreen(modelView: SplashScreenModelView())
        : const LoginScreen());
  }
}
