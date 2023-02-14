import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:edirecte/ui/styles.dart';
import 'package:edirecte/ui/screens/home_screen.dart';
import 'package:edirecte/ui/screens/grades_screen.dart';
import 'package:edirecte/ui/screens/homework_screen.dart';
import 'package:edirecte/ui/screens/schedule_screen.dart';
import 'package:edirecte/ui/screens/profile_screen.dart';
import 'package:edirecte/ui/screens/connect_screen.dart';

import 'package:edirecte/core/logic/handlers/global_handler.dart';
import 'package:edirecte/core/utils/network.dart';
import 'package:edirecte/core/utils/infos.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({super.key});

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  Future<void> _updateScreen() async {
    while (mounted) {
      while (!StoredInfos.isUserLoggedIn || Network.isConnecting) {
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 500));
      }

      await Future.delayed(const Duration(seconds: 3));
    }
  }
  
  @override
  void initState() {
    super.initState();
    _updateScreen();

    GlobalHandler.loadEverything(connect: true);
  }

  // Current page being displayed //
  int currentPageIndex = 0;

  // Function that tells the app which page is displayed //
  Widget getCurrentPage() {
    switch (currentPageIndex) {
      case 0: return const HomeScreen();
      case 1: return const GradesScreen();
      case 2: return const ScheduleScreen();
      case 3: return const HomeworkScreen();
      case 4: return const ProfileScreen();

      default: return const HomeScreen();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: EDirecteColors.mainBackgroundColor,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPageIndex,
          onTap: (value) => setState(() => { currentPageIndex = value }),
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.shifting,
          items: const [
            BottomNavigationBarItem(icon: Icon(FluentIcons.home_24_regular), activeIcon: Icon(FluentIcons.home_24_filled), label: "Accueil"),
            BottomNavigationBarItem(icon: Icon(FluentIcons.document_bullet_list_24_regular), activeIcon: Icon(FluentIcons.document_bullet_list_24_filled), label: "Notes"),
            BottomNavigationBarItem(icon: Icon(FluentIcons.clock_24_regular), activeIcon: Icon(FluentIcons.clock_24_filled), label: "Horaires"),
            BottomNavigationBarItem(icon: Icon(FluentIcons.clipboard_task_list_ltr_24_regular), activeIcon: Icon(FluentIcons.clipboard_task_list_ltr_24_filled), label: "Devoirs"),
            BottomNavigationBarItem(icon: Icon(FluentIcons.person_24_regular), activeIcon: Icon(FluentIcons.person_24_filled), label: "Profil"),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: (StoredInfos.isUserLoggedIn || currentPageIndex == 4) ? getCurrentPage() : const ConnectScreen(),
        ),
      ),
    );
  }
}