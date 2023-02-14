import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal_bottom_sheet;

import 'package:edirecte/ui/styles.dart';

class CustomBottomSheet {
  static void show(BuildContext context, double height, List<Widget> children) {
    modal_bottom_sheet.showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (context) {
        return Container(
          height: height,
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: EDirecteColors.mainWidgetBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        );
      },
    );
  }
}
