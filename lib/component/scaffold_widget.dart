import 'package:flutter/material.dart';

const Color background = Colors.redAccent;

class ScaffoldBuilder extends StatelessWidget {
  const ScaffoldBuilder(
      {super.key,
      required this.body,
      this.drawer,
      required this.title,
      this.floatingChild,
      this.onPressed,
      this.bottomNavigationBar,
      this.appBar,
      this.floatingActionButton});

  final Widget body;
  final Widget? drawer;
  final AppBar? appBar;
  final String title;
  final Widget? floatingChild;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 0,
        resizeToAvoidBottomInset: false,
        appBar: appBar ??
            AppBar(
              titleSpacing: 0,
              backgroundColor: background,
              centerTitle: true,
              title: Text(
                title,
                style: const TextStyle(fontSize: 24),
              ),
            ),
        body: body,
        drawer: drawer,
        floatingActionButton: getFloatingButton(),
        bottomNavigationBar: bottomNavigationBar);
  }

  Widget getFloatingButton() {
    if(floatingActionButton!=null) {
      return floatingActionButton!;
    }
    if (floatingChild == null || onPressed == null) {
      return const SizedBox();
    } else {
      return FloatingActionButton(
        backgroundColor: background,
        onPressed: onPressed,
        child: floatingChild,
      );
    }
  }
}
