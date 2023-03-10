import 'package:edirecte/ui/widgets/bar.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:edirecte/ui/styles.dart';
import 'package:edirecte/ui/utils.dart';
import 'package:edirecte/ui/widgets/box_widget.dart';
import 'package:edirecte/ui/widgets/connection_status.dart';
import 'package:edirecte/ui/widgets/scheduled_class_card.dart';

import 'package:edirecte/core/logic/handlers/schedule_handler.dart';
import 'package:edirecte/core/logic/objects/schedule_obj.dart';
import 'package:edirecte/core/utils/infos.dart';
import 'package:edirecte/core/utils/network.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Only update the page if it's mounted //
  @override
  void setState(VoidCallback fn) { if (mounted) super.setState(fn); }

  // This function updates the screen when it needs to //
  Future<void> _updateScreen() async {
    while (mounted) {
      while (Network.isConnecting || ScheduleHandler.isGettingSchedule) {
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() => {});
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }
  
  @override
  void initState() {
    super.initState();

    if (ScheduleHandler.actualDisplayedDayStr.compareTo(GlobalInfos.actualDayStr_) == 0) {
      ScheduleHandler.actualDisplayedDay = ScheduleHandler.nextClasses[0].beginDate;
    }

    _updateScreen();
  }
  
  // Function called at the refreshing of the page //
  Future<void> _handleRefresh() async {
    if (StoredInfos.isUserLoggedIn) {
      setState(() {
        ScheduleHandler.getSchedule().then((value) => setState(() => {}));
        ScheduleHandler.actualDisplayedDay = GlobalInfos.actualDay_;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    int currentDayScheduledClassNumber = GlobalInfos.scheduledClasses.containsKey(ScheduleHandler.actualDisplayedDayStr) ? GlobalInfos.scheduledClasses[ScheduleHandler.actualDisplayedDayStr]!.length : 0;

    if (!ScheduleHandler.loadedDays.contains(ScheduleHandler.actualDisplayedDayStr)) {
      if (!(ScheduleHandler.isGettingSpecificDay[ScheduleHandler.actualDisplayedDayStr] ?? false)) {
        ScheduleHandler.isGettingSpecificDay.putIfAbsent(ScheduleHandler.actualDisplayedDayStr, () => true);
        setState(() => {
          ScheduleHandler.getSchedule(daysMoreAndLeft: 0, eraseAll: false).then((value) => setState(() {
            ScheduleHandler.isGettingSpecificDay[ScheduleHandler.actualDisplayedDayStr] = false;
          }))
        });
      }
    }

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
                const Text("Horaires", style: EDirecteStyles.pageTitleTextStyle),
                ConnectionStatus(isChecked: Network.isConnected && ScheduleHandler.gotSchedule, isBeingChecked: Network.isConnecting || ScheduleHandler.isGettingSchedule),
              ],
            ),
          ),
          const Gap(20.0),
          BoxWidget(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(onTap: () => setState(() => {ScheduleHandler.actualDisplayedDay = ScheduleHandler.actualDisplayedDay.add(const Duration(days: -1))}), child: const Icon(FluentIcons.arrow_left_24_filled)),
                Text(dayToBeautifulStr(ScheduleHandler.actualDisplayedDay), style: EDirecteStyles.itemTitleTextStyle),
                GestureDetector(onTap: () => setState(() => {ScheduleHandler.actualDisplayedDay = ScheduleHandler.actualDisplayedDay.add(const Duration(days: 1))}), child: const Icon(FluentIcons.arrow_right_24_filled)),
              ],
            ),
          ),
          const Gap(20.0),
          Network.isConnected ? BoxWidget(
            child: currentDayScheduledClassNumber != 0 ? Column(
              children: List.generate(
                currentDayScheduledClassNumber,
                (index) {
                  String scheduledClassHour = GlobalInfos.scheduledClasses[ScheduleHandler.actualDisplayedDayStr]!.keys.elementAt(index);
                  List<ScheduledClass> scheduledClasses = GlobalInfos.scheduledClasses[ScheduleHandler.actualDisplayedDayStr]![scheduledClassHour]!;
                  
                  int pauseUntilNextHour = 0;
                  if (GlobalInfos.scheduledClasses[ScheduleHandler.actualDisplayedDayStr]!.keys.length > (index + 1)) {
                    String nextClassHour = GlobalInfos.scheduledClasses[ScheduleHandler.actualDisplayedDayStr]!.keys.elementAt(index + 1);
                    ScheduledClass nextClass = GlobalInfos.scheduledClasses[ScheduleHandler.actualDisplayedDayStr]![nextClassHour]![0];
                    pauseUntilNextHour = nextClass.beginDate.difference(scheduledClasses[0].endDate).inMinutes;
                  }
                  
                  return Column(
                    children: [
                      // Main widget //
                      ScheduledClassCard(scheduledClasses: scheduledClasses),
                      
                      // Gap after widget //
                      Gap(index == GlobalInfos.scheduledClasses[ScheduleHandler.actualDisplayedDayStr]!.length - 1 ? 0 : (pauseUntilNextHour > 15) || pauseUntilNextHour == 0 ? 10.0 : 5.0),
                      
                      // Bar to show pause before next class //
                      Bar(width: pauseUntilNextHour > 15 ? 250.0 : 200.0, height: pauseUntilNextHour > 0 ? pauseUntilNextHour > 15 ? 4.0 : 3.0 : 0.0, color: Colors.grey),
                      Gap(pauseUntilNextHour > 0 ? ((pauseUntilNextHour > 15) ? 10.0 : 5.0) : 0.0),
                    ],
                  );
                },
              ),
            ) : Center(child: Text(ScheduleHandler.isGettingSchedule ? "Chargement..." : "Pas de cours aujourd'hui !", style: EDirecteStyles.itemTextStyle)),
          ) : Container(),
          const Gap(20.0),
        ],
      ),
    );
  }
}


