import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoadingAnim extends StatefulWidget {
  double size;

  LoadingAnim({
    super.key,
    required this.size,
  });

  @override
  State<LoadingAnim> createState() => _LoadingAnimState();
}

class _LoadingAnimState extends State<LoadingAnim> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.size,
          width: widget.size,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 4.0,
          ),
        ),
      ],
    );
  }
}
