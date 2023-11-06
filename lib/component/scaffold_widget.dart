import 'package:flutter/material.dart';
const Color background = Colors.redAccent;

class ScaffoldBuilder extends StatelessWidget {
  const ScaffoldBuilder({super.key, required this.body, this.drawer,  required this.title,  this.floatingChild,  this.onPressed});
  final Widget body;
  final Widget? drawer;
  final String title;
  final Widget? floatingChild;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: drawer!=null,
      drawerEdgeDragWidth: 0,

      appBar: AppBar(

        titleSpacing: 0,
        backgroundColor: background,
        title: Text(
          title,
          style: const TextStyle(fontSize: 24),
        ),
      ),
      body: body,
      drawer: drawer,
      floatingActionButton:getFloatingButton(),
    );
  }
  getFloatingButton(){
    if(floatingChild == null && onPressed == null){
     return null;
    }else {
      return  FloatingActionButton(
      backgroundColor: background,
      onPressed: onPressed,
      child: floatingChild,
    );
    }

  }
}
