import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return  loadingScreen();
  }
  loadingScreen() => Scaffold(
    backgroundColor: backgroundColor,
    body: Center(
      child: Stack(alignment: alignment, children: [
        LoadingIndicator(
          indicatorType: indicatorType,
          colors: indicatorColors,
        ),
        Text(
         loadingText,
          style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.white),
        )
      ]),
    ),
  );
  get backgroundColor => Colors.blueGrey;

  get alignment => Alignment.center;

  get indicatorType => Indicator.ballScale;

  get indicatorColors => [Colors.deepPurple, Colors.deepOrangeAccent];

  String get loadingText =>  "Loading";

}
