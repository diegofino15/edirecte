import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import 'package:edirecte/ui/styles.dart';
import 'package:edirecte/ui/utils.dart';
import 'package:edirecte/ui/widgets/bottom_sheet.dart';

import 'package:edirecte/core/logic/objects/grades_obj.dart';
import 'package:edirecte/core/logic/objects/subject_obj.dart';
import 'package:edirecte/core/utils/infos.dart';

class SubjectCard extends StatefulWidget {
  final Subject subject;

  const SubjectCard({
    super.key,
    required this.subject,
  });

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  // Popup opened on subject click //
  void _subjectPopup() {
    CustomBottomSheet.show(
      context,
      140.0,
      [
        Row(
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: EDirecteColors.getSubjectColor(widget.subject.code, 0),
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Center(child: Text(widget.subject.average[GlobalInfos.currentPeriodCode].toString().replaceAll(".", ","), style: EDirecteStyles.numberTextStyle)),
            ),
            const Gap(20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.subject.name, style: EDirecteStyles.itemTitleTextStyle.copyWith(fontWeight: FontWeight.bold)),
                const Gap(10.0),
                SizedBox(
                  width: 200.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Classe : ${widget.subject.averageClass[GlobalInfos.currentPeriodCode]}", style: EDirecteStyles.itemTextStyle),
                      const Text("-", style: EDirecteStyles.itemTextStyle),
                      Text("Coef : ${rem0(widget.subject.coefficient)}", style: EDirecteStyles.itemTextStyle),
                    ],
                  ),
                ),
                const Gap(10.0),
                Text(widget.subject.professorName, style: EDirecteStyles.itemTextStyle),
              ],
            ),
          ],
        ),
      ],
    );
  }
  
  // Popup opened on grade click //
  void _gradePopup(Grade grade) {
    CustomBottomSheet.show(
      context,
      140.0,
      [
        Row(
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: EDirecteColors.getSubjectColor(grade.subjectCode, 1),
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Center(child: Text(grade.showableStr, style: EDirecteStyles.numberTextStyle)),
            ),
            const Gap(20.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200.0,
                  child: Text(grade.title, style: EDirecteStyles.itemTitleTextStyle.copyWith(fontWeight: FontWeight.bold), maxLines: 2),
                ),
                const Gap(10.0),
                SizedBox(
                  width: 200.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Classe : ${grade.classValue}", style: EDirecteStyles.itemTextStyle),
                      const Text("-", style: EDirecteStyles.itemTextStyle),
                      Text("Coef : ${rem0(grade.coefficient)}", style: EDirecteStyles.itemTextStyle),
                    ],
                  ),
                ),
                const Gap(10.0),
                Text(dayToBeautifulStr(grade.dateEntered), style: EDirecteStyles.itemTextStyle),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.0,
      decoration: BoxDecoration(
        color: EDirecteColors.getSubjectColor(widget.subject.code, 1),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _subjectPopup,
            child: Container(
              height: 40.0,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: EDirecteColors.getSubjectColor(widget.subject.code, 0),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.subject.name, style: EDirecteStyles.itemTitleTextStyle),
                  Text(rem0(widget.subject.average[GlobalInfos.currentPeriodCode] ?? 0.0), style: EDirecteStyles.numberTextStyle.copyWith(fontSize: 22.0)),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            height: 45.0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              itemCount: widget.subject.grades.containsKey(GlobalInfos.currentPeriodCode) ? widget.subject.grades[GlobalInfos.currentPeriodCode]!.length : 0,
              itemBuilder: (BuildContext c, int index) {
                Grade grade = widget.subject.grades[GlobalInfos.currentPeriodCode]![index];
                return GestureDetector(
                  onTap: () => _gradePopup(grade),
                  child: Text(grade.showableStr, style: EDirecteStyles.numberTextStyle.copyWith(fontSize: 20.0)),
                );
              },
              separatorBuilder: (BuildContext c, int index) {
                return SizedBox(width: index == widget.subject.grades[GlobalInfos.currentPeriodCode]!.length - 1 ? 0.0 : 15.0);
              },
            ),
          ),
        ],
      ),
    );
  }
}
