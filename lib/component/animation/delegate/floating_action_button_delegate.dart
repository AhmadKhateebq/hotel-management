import 'package:flutter/material.dart';

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({required this.menuAnimation})
      : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double width = 60;
    final coordinates = <List<double>>[
      [-width * menuAnimation.value, -0],
      [-width * menuAnimation.value, -width * menuAnimation.value],
      [0, -width * menuAnimation.value],
      [width * menuAnimation.value, -width * menuAnimation.value],
      [width * menuAnimation.value, -0],
    ];
    // double dx = 0.0;
    for (int i = 0; i < context.childCount; ++i) {
      // dx = width * (i + 1);
      context.paintChild(
        i,
        // transform: Matrix4.translationValues(
        //   dx * menuAnimation.value,
        //   -dx * menuAnimation.value,
        //   0,
        // ),
        transform: Matrix4.translationValues(
          coordinates[i][0],
          coordinates[i][1],
          0,
        ),
      );
    }
  }
}
