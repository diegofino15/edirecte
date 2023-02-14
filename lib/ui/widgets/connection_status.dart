import 'package:flutter/material.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:edirecte/ui/widgets/loading_animation.dart';

class ConnectionStatus extends StatelessWidget {
  final bool isChecked;
  final bool isBeingChecked;

  const ConnectionStatus({
    super.key,
    required this.isChecked,
    required this.isBeingChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isChecked
          ? const Icon(FluentIcons.checkmark_24_filled, color: Colors.green, size: 25.0)
          : isBeingChecked
              ? LoadingAnim(size: 20.0)
              : Container(),
    );
  }
}
