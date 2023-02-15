import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import 'package:edirecte/ui/styles.dart';

import 'package:edirecte/core/logic/objects/grades_obj.dart';

class GradeCard extends StatelessWidget {
  final Grade grade;

  const GradeCard({
    super.key,
    required this.grade
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      height: 70.0,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: EDirecteColors.mainBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(width: 0.0, color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: EDirecteColors.getSubjectColor(grade.subjectCode, 1),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Center(child: Text(grade.showableStr, style: EDirecteStyles.numberTextStyle.copyWith(fontSize: (grade.valueOn == 20) && grade.isEffective ? 22.0 : 17.0))),
          ),
          const Gap(10.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 170.0,
                height: 20.0,
                child: Text(
                  grade.title,
                  style: EDirecteStyles.itemTitleTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 170.0,
                height: 20.0,
                child: Text(
                  grade.subjectName,
                  style: EDirecteStyles.itemTextStyle,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
