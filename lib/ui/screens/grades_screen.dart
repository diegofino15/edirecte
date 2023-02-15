import 'dart:math';

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import 'package:edirecte/ui/styles.dart';
import 'package:edirecte/ui/utils.dart';
import 'package:edirecte/ui/widgets/box_widget.dart';
import 'package:edirecte/ui/widgets/connection_status.dart';
import 'package:edirecte/ui/widgets/grade_card.dart';
import 'package:edirecte/ui/widgets/subject_card.dart';
import 'package:edirecte/ui/widgets/bottom_sheet.dart';

import 'package:edirecte/core/logic/handlers/grades_handler.dart';
import 'package:edirecte/core/logic/objects/subject_obj.dart';
import 'package:edirecte/core/utils/infos.dart';
import 'package:edirecte/core/utils/network.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  // Only update the page if it's mounted //
  @override
  void setState(VoidCallback fn) { if (mounted) super.setState(fn); }
  
  // This function updates the screen when it needs to //
  Future<void> _updateScreen() async {
    while (mounted) {
      while (Network.isConnecting || GradesHandler.isGettingGrades) {
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() => {});
      }

      if (Network.isConnected && !GradesHandler.gotGrades && !GradesHandler.isGettingGrades) {
        setState(() => {GradesHandler.getGrades().then((value) => setState(() => {}))});
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
      setState(() => {GradesHandler.getGrades().then((value) => setState(() => {}))});
    }
  }

  // Function called on general average click //
  void _generalAveragePopup() {
    CustomBottomSheet.show(
      context,
      140,
      [
        Row(
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Center(child: Text(rem0(GlobalInfos.generalAverage.average[GlobalInfos.currentPeriodCode] ?? 0.0), style: EDirecteStyles.numberTextStyle)),
            ),
            const Gap(20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Moyenne générale", style: EDirecteStyles.itemTitleTextStyle.copyWith(fontWeight: FontWeight.bold)),
                const Gap(10.0),
                SizedBox(
                  width: 200.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Classe : ${GlobalInfos.generalAverage.averageClass[GlobalInfos.currentPeriodCode]}", style: EDirecteStyles.itemTextStyle),
                      const Text("-", style: EDirecteStyles.itemTextStyle),
                      Text("Trimestre ${GlobalInfos.currentPeriodIndex}", style: EDirecteStyles.itemTextStyle),
                    ],
                  ),
                ),
                const Gap(10.0),
                Text(Infos.studentFullName, style: EDirecteStyles.itemTextStyle),
              ],
            ),
          ],
        ),
      ]
    );
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
                const Text("Notes et moyennes", style: EDirecteStyles.pageTitleTextStyle),
                ConnectionStatus(isChecked: Network.isConnected && GradesHandler.gotGrades, isBeingChecked: Network.isConnecting || GradesHandler.isGettingGrades),
              ],
            ),
          ),
          const Gap(20.0),
          BoxWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Trimestre ${GradesHandler.gotGrades ? GlobalInfos.currentPeriodIndex : "--"}", style: EDirecteStyles.sectionTitleTextStyle),
                const Gap(20.0),
                Center(
                  child: GestureDetector(
                    onTap: _generalAveragePopup,
                    child: Column(
                      children: [
                        Text(GradesHandler.gotGrades ? GlobalInfos.generalAverage.average[GlobalInfos.currentPeriodCode].toString().replaceAll(".", ",") : "--", style: EDirecteStyles.numberTextStyle),
                        Text("MOYENNE GÉNÉRALE", style: EDirecteStyles.itemTextStyle.copyWith(fontFamily: "Sofia", fontSize: 17.0)),
                      ],
                    ),
                  ),
                ),
                const Gap(30.0),
                const Text("Dernières notes", style: EDirecteStyles.sectionTitleTextStyle),
                const Gap(10.0),
                SizedBox(
                  height: 70.0,
                  child: ListView.separated(
                    key: const PageStorageKey(1),
                    scrollDirection: Axis.horizontal,
                    itemCount: GradesHandler.gotGrades ? min(20, GlobalInfos.grades.length) : 0,
                    itemBuilder: (BuildContext c, int index) {
                      return GradeCard(grade: GlobalInfos.grades[GlobalInfos.grades.length - index - 1]);
                    },
                    separatorBuilder: (BuildContext c, int index) {
                      return Gap(index == min(20, GlobalInfos.grades.length) - 1 ? 0.0 : 10.0);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Gap(20.0),
          BoxWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Moyennes par matière", style: EDirecteStyles.sectionTitleTextStyle),
                Column(
                  children: List.generate(
                    GradesHandler.gotGrades ? GlobalInfos.subjects.length : 0,
                    (index) {
                      Subject subject = GlobalInfos.subjects[GlobalInfos.subjects.keys.elementAt(index)]!;
                      
                      if (subject.average.containsKey(GlobalInfos.currentPeriodCode)) {
                        return Column(
                          children: [
                            const Gap(20.0),
                            SubjectCard(subject: subject),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
          const Gap(20.0),
        ],
      ),
    );
  }
}