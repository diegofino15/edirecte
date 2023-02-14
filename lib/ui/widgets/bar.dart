import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const Bar({
    super.key,
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(2.0)),
      ),
    );
  }
}
