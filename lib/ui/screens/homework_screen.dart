import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import 'package:edirecte/ui/styles.dart';
import 'package:edirecte/ui/widgets/box_widget.dart';
import 'package:edirecte/ui/widgets/connection_status.dart';
import 'package:edirecte/ui/widgets/homework_card.dart';

import 'package:edirecte/core/logic/handlers/homework_handler.dart';
import 'package:edirecte/core/logic/objects/homework_obj.dart';
import 'package:edirecte/core/utils/infos.dart';
import 'package:edirecte/core/utils/network.dart';

class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  // Only update the page if it's mounted //
  @override
  void setState(VoidCallback fn) { if (mounted) super.setState(fn); }
  
  // This function updates the screen when it needs to //
  Future<void> _updateScreen() async {
    while (mounted) {
      while (Network.isConnecting || HomeworkHandler.isGettingHomework) {
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() => {});
      }

      if (Network.isConnected && !HomeworkHandler.gotHomework && !HomeworkHandler.isGettingHomework) {
        setState(() => {HomeworkHandler.getFutureHomework().then((value) => setState(() => {}))});
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }
  
  @override
  void initState() {
    super.initState();
    _updateScreen();
  }

  // Function called at the refreshing of the page //
  Future<void> _handleRefresh() async {
    if (StoredInfos.isUserLoggedIn) {
      setState(() => {HomeworkHandler.getFutureHomework().then((value) => setState(() => {}))});
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const Gap(10.0),
          BoxWidget(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Devoirs à faire", style: EDirecteStyles.pageTitleTextStyle),
                ConnectionStatus(isChecked: Network.isConnected && HomeworkHandler.gotHomework, isBeingChecked: Network.isConnecting || HomeworkHandler.isGettingHomework),
              ],
            ),
          ),
          const Gap(20.0),
          BoxWidget(
            child: Column(
              children: !HomeworkHandler.isGettingHomework ? List.generate(
                HomeworkHandler.gotHomework ? GlobalInfos.homeworks.length : 0,
                (index) {
                  String day = GlobalInfos.homeworks.keys.elementAt(index);
                  HomeworkDay homeworkDay = GlobalInfos.homeworks[day]!;
                  return HomeworkCard(homework: homeworkDay, drawIndex: index);
                },
              ) : [
                const Text("Chargement...", style: EDirecteStyles.itemTextStyle),
              ],
            ),
          ),
          const Gap(20.0),
        ],
      ),
    );
  }
}