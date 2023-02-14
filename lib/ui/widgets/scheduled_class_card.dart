import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import 'package:edirecte/ui/styles.dart';
import 'package:edirecte/ui/widgets/bar.dart';

import 'package:edirecte/core/logic/objects/schedule_obj.dart';

// ignore: must_be_immutable
class ScheduledClassCard extends StatelessWidget {
  final List<ScheduledClass> scheduledClasses;

  const ScheduledClassCard({
    super.key,
    required this.scheduledClasses
  });

  @override
  Widget build(BuildContext context) {
    if (scheduledClasses.isEmpty) {
      return const Text("Pas de cours !", style: EDirecteStyles.itemTextStyle);
    }

    return Container(
      height: 80.0,
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: EDirecteColors.mainBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Row(
        children: scheduledClasses.length == 1 ? [
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: Column(
              children: [
                Text(scheduledClasses[0].beginHour, style: EDirecteStyles.itemTextStyle),
                const Bar(width: 3.0, height: 10.0, color: Colors.grey),
                Text(scheduledClasses[0].endHour, style: EDirecteStyles.itemTextStyle),
              ],
            ),
          ),
          const Gap(5.0),
          Bar(width: 3.0, height: 50.0, color: EDirecteColors.getSubjectColor(scheduledClasses[0].subject.code, 1)),
          const Gap(10.0),
          SizedBox(
            width: MediaQuery.of(context).size.width - 168,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(scheduledClasses[0].subject.name, style: EDirecteStyles.itemTitleTextStyle.copyWith(fontSize: 15.0), overflow: TextOverflow.ellipsis),
                const Gap(5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width - 100 - 68 - 40, child: Text(scheduledClasses[0].subject.professorName, style: EDirecteStyles.itemTextStyle, overflow: TextOverflow.ellipsis)),
                    Text("- ${scheduledClasses[0].classroom.replaceAll(",", "")}", style: EDirecteStyles.itemTextStyle, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
        ] : [
          // Widgets shown if there are 2 classes on the same hour //
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: Column(
              children: [
                Text(scheduledClasses[0].beginHour, style: EDirecteStyles.itemTextStyle),
                const Bar(width: 3.0, height: 10.0, color: Colors.grey),
                Text(scheduledClasses[0].endHour, style: EDirecteStyles.itemTextStyle),
              ],
            ),
          ),
          const Gap(5.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Bar(width: 3.0, height: 24.0, color: EDirecteColors.getSubjectColor(scheduledClasses[0].subject.code, 1)),
                  const Gap(10.0),
                  Text(scheduledClasses[0].subject.name, style: EDirecteStyles.itemTitleTextStyle.copyWith(fontSize: 15.0)),
                ],
              ),
              const Gap(2.0),
              Row(
                children: [
                  Bar(width: 3.0, height: 24.0, color: EDirecteColors.getSubjectColor(scheduledClasses[1].subject.code, 1)),
                  const Gap(10.0),
                  Text(scheduledClasses[1].subject.name, style: EDirecteStyles.itemTitleTextStyle.copyWith(fontSize: 15.0)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}


