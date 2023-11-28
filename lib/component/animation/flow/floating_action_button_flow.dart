import 'package:flutter/material.dart';
import 'package:hotel_management/component/animation/delegate/floating_action_button_delegate.dart';

class FloatingActionButtonFlow extends StatefulWidget {
  const FloatingActionButtonFlow(
      {super.key, required this.icons, required this.functions});

  final List<IconData> icons;
  final List<void Function()> functions;

  @override
  State<FloatingActionButtonFlow> createState() =>
      _FloatingActionButtonFlowState();
}

class _FloatingActionButtonFlowState extends State<FloatingActionButtonFlow>
    with SingleTickerProviderStateMixin {
  late AnimationController menuAnimation;
  IconData lastTapped = Icons.notifications;
  late List<IconData> menuItems;
  late List<void Function()> functions;
  bool _pressed = false;

  // void _updateMenu(IconData icon) {
  //   int index = menuItems.indexOf(icon);
  //   for (int i = 1; i < menuItems.length; i++) {
  //     if (menuItems[index] == icon) {
  //       menuItems[index] = menuItems[menuItems.length - 1];
  //       menuItems[menuItems.length - 1] = icon;
  //       //--
  //       var temp = functions[index];
  //       functions[index] = functions[menuItems.length - 1];
  //       functions[menuItems.length - 1] = temp;
  //       break;
  //     }
  //   }
  //   if (icon != Icons.menu) {
  //     lastTapped = icon;
  //   }
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    menuItems = [...widget.icons];
    functions = [...widget.functions];
    menuAnimation = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  Widget flowMenuItem(IconData icon, void Function() function,
      {bool? bg = false}) {
    const double buttonDiameter = 40;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: IconButton(
          style: IconButton.styleFrom(
            iconSize: buttonDiameter,
            backgroundColor: (bg ?? false)
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primaryContainer,
          ),
          // constraints:
          //     BoxConstraints.tight(const Size(buttonDiameter, buttonDiameter)),
          onPressed: () {
            // _updateMenu(icon);
            menuAnimation.status == AnimationStatus.completed
                ? menuAnimation.reverse()
                : menuAnimation.forward();
            if (_pressed) {
              function.call();
            }
            _pressed = !_pressed;
          },
          icon: Icon(
            icon,
            color: bg ?? false
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
            // size: 45.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Stack(
      children: [
        Flow(
            delegate: FlowMenuDelegate(menuAnimation: menuAnimation),
            children: menuItems
                .map<Widget>(
                    (IconData icon) => flowMenuItem(icon, functions[i++]))
                .toList()),
        flowMenuItem(Icons.navigation, () {}, bg: true),
      ],
    );
  }
}
