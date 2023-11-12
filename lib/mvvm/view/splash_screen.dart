import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/view_model/splash_screen_model_view.dart';
import 'package:loading_indicator/loading_indicator.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, required this.modelView});
  final SplashScreenModelView modelView;
  @override
  Widget build(BuildContext context) {
    return  loadingScreen();
  }
  loadingScreen() => Scaffold(
    backgroundColor: modelView.backgroundColor,
    body: Center(
      child: Stack(alignment: modelView.alignment, children: [
        LoadingIndicator(
          indicatorType: modelView.indicatorType,
          colors: modelView.indicatorColors,
        ),
        Text(
         modelView.loadingText,
          style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.white),
        )
      ]),
    ),
  );

}
