import 'package:flutter/cupertino.dart';
import 'package:hotel_management/mvvm/view/components/loading_widget.dart';
import 'package:hotel_management/mvvm/view_model/loading_screen_view_model.dart';
import 'package:hotel_management/mvvm/view_model/splash_screen_view_model.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenViewModel viewModel = SplashScreenViewModel();
  @override
  void initState() {
    viewModel.initApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  LoadingWidget(modelView: LoadingWidgetViewModel());
  }
}
