import 'package:flutter/material.dart';
import 'package:hotel_management/parallax_test/data_container.dart';
import 'package:hotel_management/mvvm/view/components/flow/parallax_image.dart';

class ParallaxRecipe extends StatelessWidget {
  const ParallaxRecipe({super.key, required this.list});
  final List<ParallaxContainer> list;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parallax Test'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (final object in list)
              ParallaxImage(
                imageUrl: object.imageUrl,
              ),
          ],
        ),
      ),
    );
  }
}