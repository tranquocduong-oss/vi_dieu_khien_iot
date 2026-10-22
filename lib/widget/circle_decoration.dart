import 'package:flutter/material.dart';

class CircleDecoration extends StatelessWidget {
  final double size;
  final List<Color> colors;

  const CircleDecoration({
    super.key,
    required this.size,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
    );
  }
}