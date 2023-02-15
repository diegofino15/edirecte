import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:edirecte/ui/styles.dart';
import 'package:edirecte/ui/widgets/bar.dart';

import 'package:edirecte/core/logic/objects/timeline_obj.dart';

class TimelineCard extends StatelessWidget {
  final TimelineEvent timelineEvent;

  const TimelineCard({
    super.key,
    required this.timelineEvent
  });

  Widget getTimelineEventIcon() {
    switch (timelineEvent.type) {
      case "Messagerie": return const Icon(FluentIcons.mail_24_filled, size: 50.0);
      case "Note": return const Icon(FluentIcons.document_bullet_list_24_regular, size: 50.0);
      case "Document": return const Icon(FluentIcons.document_24_filled, size: 50.0, color: Colors.blueGrey);
      case "VieScolaire": return const Icon(FluentIcons.gavel_24_filled, size: 50.0, color: Colors.red);

      default: return const Icon(FluentIcons.error_circle_24_filled, size: 50.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      height: 90.0,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: EDirecteColors.mainBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(width: 0.0, color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: Center(child: getTimelineEventIcon()),
          ),
          const Gap(10.0),
          const Bar(width: 2.0, height: 100.0, color: Colors.grey),
          const Gap(20.0),
          SizedBox(
            width: MediaQuery.of(context).size.width - 202,
            height: 90.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(timelineEvent.title, style: EDirecteStyles.itemTextStyle.copyWith(color: Colors.black, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                const Gap(5.0),
                Text(timelineEvent.content, style: EDirecteStyles.itemTextStyle.copyWith(color: Colors.black), overflow: TextOverflow.ellipsis, maxLines: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
