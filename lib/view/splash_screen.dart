import 'package:flutter/cupertino.dart';
import 'package:hotel_management/component/loading_widget.dart';
import 'package:hotel_management/util/file_output.dart';
import 'package:hotel_management/view_model/splash_screen_view_model.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String routeName = '/';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenViewModel viewModel = SplashScreenViewModel();
  @override
  void initState() {
    viewModel.initApp();
    CustomLogger.logger.i('splash screen init',time: DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  const LoadingWidget();
  }
}
