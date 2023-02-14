import 'package:flutter/material.dart';

import 'package:edirecte/ui/styles.dart';

class BoxWidget extends StatelessWidget {
  final Widget child;
  final bool? isSecondColor;

  const BoxWidget({
    super.key,
    required this.child,
    this.isSecondColor = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: (isSecondColor ?? false) ? EDirecteColors.mainBackgroundColor : EDirecteColors.mainWidgetBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      child: child,
    );
  }
}
