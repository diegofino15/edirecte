import 'package:flutter/material.dart';

import 'package:edirecte/ui/screen_manager.dart';

void main() {
  runApp(const EDirecte());
}

class EDirecte extends StatelessWidget {
  const EDirecte({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "EDirecte",
      debugShowCheckedModeBanner: false,
      home: ScreenManager(),
    );
  }
}
