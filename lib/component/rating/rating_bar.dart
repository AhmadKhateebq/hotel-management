import 'package:flutter/material.dart';

import 'half_filled_icon.dart';
class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar({super.key, required this.rating});
  final double rating;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: getStarts(rating),
    );
  }

  getStarts(double stars) {
    List<Widget> starList = [];
    int i = 0;
    while (i < 5) {
      if (stars >= 1) {
        starList.add(const Icon(
          Icons.star,
          fill: .5,
          color: Colors.orange,
        ));
        stars = stars - 1;
      } else if (stars < 1 && stars > 0) {
        starList
            .add(const HalfFilledIcon(icon: Icons.star, color: Colors.orange));
        stars = 0;
      } else if (stars == 0) {
        starList.add(Icon(
          Icons.star,
          color: Colors.grey[300],
        ));
      }
      i++;
    }
    return starList;
  }
}
