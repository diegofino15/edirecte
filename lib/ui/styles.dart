import 'package:flutter/material.dart';

// This class contains all colors used in the app //
class EDirecteColors {
  static const Color mainBackgroundColor = Color(0xFFececec);
  static const Color mainWidgetBackgroundColor = Color(0xFFf6f6f6);

  // Subject colors //
  static const List<List<Color>> subjectColors = [
    [Color(0xFFff6242), Color(0xFFFFA590)], // Red
    [Color(0xFF5BAEB7), Color(0xFFA5DEF2)], // Blue
    [Color(0xFFFCCF55), Color(0xFFFDDF8E)], // Yellow
    [Color(0xFF658354), Color(0xFFA3C585)], // Green
    [Color(0xFFA17BB9), Color(0xFFC09ADB)], // Purple
  ];
  static Map<dynamic, dynamic> attribuatedSubjectColors = {};
  static int currentColorIndex = 0;

  static Color getSubjectColor(String subjectCode, int colorIndex) {
    if (!EDirecteColors.attribuatedSubjectColors.containsKey(subjectCode)) {
      EDirecteColors.attribuatedSubjectColors.addAll({subjectCode: EDirecteColors.currentColorIndex});

      EDirecteColors.currentColorIndex += 1;
      if (EDirecteColors.currentColorIndex == EDirecteColors.subjectColors.length) {
        EDirecteColors.currentColorIndex = 0;
      }
    }

    return subjectColors[attribuatedSubjectColors[subjectCode]!][colorIndex];
  }
}

// This class contains all styles used for text in the app //
class EDirecteStyles {
  static const TextStyle pageTitleTextStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontFamily: "Bitter"
  );

  static const TextStyle sectionTitleTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    fontFamily: "Montserrat"
  );

  static const TextStyle itemTitleTextStyle = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: "Montserrat"
  );

  static const TextStyle itemTextStyle = TextStyle(
    fontSize: 15.0,
    color: Colors.black54,
    fontFamily: "Montserrat"
  );

  static const TextStyle numberTextStyle = TextStyle(
    fontSize: 32.0,
    color: Colors.black87,
    fontFamily: "Bitter",
    fontWeight: FontWeight.bold,
  );
}

