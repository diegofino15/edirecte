import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:edirecte/ui/styles.dart';
import 'package:edirecte/ui/utils.dart';
import 'package:edirecte/ui/widgets/bar.dart';
import 'package:edirecte/ui/widgets/bottom_sheet.dart';
import 'package:edirecte/ui/widgets/loading_animation.dart';

import 'package:edirecte/core/logic/objects/homework_obj.dart';
import 'package:edirecte/core/utils/infos.dart';

class HomeworkCard extends StatefulWidget {
  final HomeworkDay? homework;
  final int drawIndex;

  const HomeworkCard({
    super.key,
    required this.homework,
    required this.drawIndex,
  });

  @override
  State<HomeworkCard> createState() => _HomeworkCardState();
}

class _HomeworkCardState extends State<HomeworkCard> { 
  @override
  void setState(VoidCallback fn) { if (mounted) super.setState(fn); }

  // Function used to update the screen once a homework has loaded //
  Future<void> _updateHomeworkWidget() async {
    while (widget.homework!.isGettingContent) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    if (widget.homework == null) return;
    _updateHomeworkWidget();
  }

  // Popup opening on homework click //
  void _homeworkPopup(Homework homework) {
    CustomBottomSheet.show(
      context,
      400.0,
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(homework.subject.name, style: EDirecteStyles.pageTitleTextStyle),
            homework.isExam ? const Icon(FluentIcons.warning_24_filled, color: Colors.red, size: 25.0) : Container(),
          ],
        ),
        const Gap(5.0),
        Text("Donné le ${dayToBeautifulStr(homework.day)}", style: EDirecteStyles.itemTextStyle),
        const Gap(10.0),
        Bar(width: MediaQuery.of(context).size.width, height: 3.0, color: EDirecteColors.getSubjectColor(homework.subject.code, 1)),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 290.0,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            children: [Text(homework.content!, style: EDirecteStyles.itemTextStyle)],
          )
        ),
        Bar(width: MediaQuery.of(context).size.width, height: 3.0, color: EDirecteColors.getSubjectColor(homework.subject.code, 1)),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.homework == null) return Container();
    
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: EDirecteColors.mainBackgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(width: 0.0, color: Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dayToBeautifulStr(widget.homework!.day), style: EDirecteStyles.itemTitleTextStyle),
                  widget.homework!.isGettingContent ? LoadingAnim(size: 20.0) : Container(),
                ],
              ),
              const Gap(20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  widget.homework!.homeworks.length,
                  (index) {
                    int id = widget.homework!.homeworks.keys.elementAt(index);
                    Homework homework = widget.homework!.homeworks[id]!;

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => {
                            if (!widget.homework!.isGettingContent) _homeworkPopup(homework)
                          },
                          child: Container(
                            // To be clickable on the whole row //
                            decoration: const BoxDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Bar(width: 3.0, height: 50.0, color: EDirecteColors.getSubjectColor(homework.subject.code, 0)),
                                    const Gap(10.0),
                                    Text(homework.subject.name, style: EDirecteStyles.itemTextStyle.copyWith(color: homework.isExam ? Colors.red : Colors.black54))
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    homework.isDone = !homework.isDone;
                                    homework.setDone(homework.isDone).then((value) => setState(() => {}));
                                  }),
                                  child: Icon(homework.isDone ? FluentIcons.checkbox_checked_24_filled : FluentIcons.checkbox_unchecked_24_regular),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(index == widget.homework!.homeworks.length - 1 ? 0.0 : 10.0),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Gap(widget.drawIndex == GlobalInfos.homeworks.length - 1 ? 0.0 : 20.0),
      ],
    );
  }
}
