import 'dart:math';

import 'package:edirecte/core/logic/objects/homework_obj.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import 'package:edirecte/ui/styles.dart';
import 'package:edirecte/ui/utils.dart';
import 'package:edirecte/ui/widgets/box_widget.dart';
import 'package:edirecte/ui/widgets/connection_status.dart';
import 'package:edirecte/ui/widgets/grade_card.dart';
import 'package:edirecte/ui/widgets/loading_animation.dart';
import 'package:edirecte/ui/widgets/scheduled_class_card.dart';
import 'package:edirecte/ui/widgets/timeline_card.dart';
import 'package:edirecte/ui/widgets/homework_card.dart';

import 'package:edirecte/core/logic/handlers/global_handler.dart';
import 'package:edirecte/core/logic/handlers/grades_handler.dart';
import 'package:edirecte/core/logic/handlers/schedule_handler.dart';
import 'package:edirecte/core/logic/handlers/timeline_handler.dart';
import 'package:edirecte/core/logic/handlers/homework_handler.dart';

import 'package:edirecte/core/utils/infos.dart';
import 'package:edirecte/core/utils/network.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Only update the page if it's mounted //
  @override
  void setState(VoidCallback fn) { if (mounted) super.setState(fn); }
  
  // This function updates the screen when it needs to //
  Future<void> _updateScreen() async {
    GlobalHandler.isUpdated;
    
    while (mounted) {
      while (Network.isConnecting || !GlobalHandler.isEverythingUpdated() || !ScheduleHandler.calculatedNextClass) {
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() => {});
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
      setState(() {
        GlobalHandler.loadEverything(connect: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeworkDay? nextHomework = HomeworkHandler.getNextHomework();
    if (!ScheduleHandler.calculatedNextClass) ScheduleHandler.calculateNextClass();

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView(
        children: [
          const Gap(10.0),
          BoxWidget(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Network.isConnected ? "Bonjour ${Infos.studentFirstName} !" : "Connexion...", style: EDirecteStyles.pageTitleTextStyle),
                ConnectionStatus(isChecked: GlobalHandler.isEverythingUpdated(), isBeingChecked: Network.isConnecting || !GlobalHandler.isEverythingUpdated()),
              ],
            ),
          ),
          const Gap(20.0),
          // Grades widget //
          BoxWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Moyenne générale", style: EDirecteStyles.itemTitleTextStyle),
                    GradesHandler.gotGrades ? Text(GlobalInfos.generalAverage.average[GlobalInfos.currentPeriodCode].toString().replaceAll(".", ","), style: EDirecteStyles.numberTextStyle.copyWith(fontSize: 25.0)) : LoadingAnim(size: 20.0),
                  ],
                ), 
                Gap(GradesHandler.gotGrades ? 10.0 : 0.0),
                GradesHandler.gotGrades ?  SizedBox(
                  height: 70.0,
                  child: ListView.separated(
                    key: const PageStorageKey(0),
                    scrollDirection: Axis.horizontal,
                    itemCount: GradesHandler.gotGrades ? min(10, GlobalInfos.grades.length) : 0,
                    itemBuilder: (BuildContext c, int index) {
                      return GradeCard(grade: GlobalInfos.grades[GlobalInfos.grades.length - index - 1]);
                    },
                    separatorBuilder: (BuildContext c, int index) {
                      return Gap(index == min(10, GlobalInfos.grades.length) - 1 ? 0.0 : 10.0);
                    },
                  ),
                ) : Container(),
              ],
            ),
          ),
          const Gap(20.0),
          // Scheduled class widget //
          BoxWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Prochain cours", style: EDirecteStyles.itemTitleTextStyle),
                    ScheduleHandler.gotSchedule ? Text(ScheduleHandler.calculatedNextClass ? "dans ${formatDuration(ScheduleHandler.timeBeforeNextClass)}" : "--", style: EDirecteStyles.itemTitleTextStyle) : LoadingAnim(size: 20.0),
                  ],
                ),
                Gap(ScheduleHandler.gotSchedule ? 10.0 : 0.0),
                ScheduleHandler.gotSchedule ? ScheduledClassCard(scheduledClasses: ScheduleHandler.nextClasses, showOutline: false) : Container(),
              ],
            ),
          ),
          const Gap(20.0),
          // Homework widget //
          BoxWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Prochains devoirs", style: EDirecteStyles.itemTitleTextStyle),
                    HomeworkHandler.gotHomework ? Container() : LoadingAnim(size: 20.0),
                  ],
                ),
                Gap(HomeworkHandler.gotHomework ? 10.0 : 0.0),
                HomeworkHandler.gotHomework
                  ? GlobalInfos.homeworks.isNotEmpty && nextHomework != null
                    ? HomeworkCard(homework: nextHomework, drawIndex: GlobalInfos.homeworks.keys.length - 1)
                    : const Text("Pas de devoirs !", style: EDirecteStyles.itemTextStyle)
                  : Container(),
              ],
            ),
          ),
          const Gap(20.0),
          // Timeline widget //
          BoxWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Dernières nouvelles", style: EDirecteStyles.itemTitleTextStyle),
                    TimelineHandler.gotTimeline ? Container() : LoadingAnim(size: 20.0),
                  ],
                ),
                Gap(TimelineHandler.gotTimeline ? 10.0 : 0.0),
                TimelineHandler.gotTimeline ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 90.0,
                  child: ListView.separated(
                    itemCount: min(10, GlobalInfos.timelineEvents.length),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext c, int index) {
                      return TimelineCard(timelineEvent: GlobalInfos.timelineEvents[index]);
                    },
                    separatorBuilder: (BuildContext c, int index) {
                      return Gap(index == min(10, GlobalInfos.timelineEvents.length) - 1 ? 0.0 : 10.0);
                    },
                  ),
                ) : Container(),
              ],
            ),
          ),
          const Gap(20.0),
        ],
      ),
    );
  }
}