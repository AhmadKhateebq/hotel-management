import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidgetViewModel{
  get backgroundColor => Colors.blueGrey;

  get alignment => Alignment.center;

  get indicatorType => Indicator.ballScale;

  get indicatorColors => [Colors.deepPurple, Colors.deepOrangeAccent];

  String get loadingText =>  "Loading";

}