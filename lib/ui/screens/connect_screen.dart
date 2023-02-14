import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:edirecte/ui/styles.dart';
import 'package:edirecte/ui/widgets/box_widget.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        const Gap(10.0),
        BoxWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Vous n'êtes pas connecté", style: EDirecteStyles.pageTitleTextStyle),
              Gap(5.0),
              Text("Connectez vous sur votre profil", style: EDirecteStyles.itemTextStyle),
            ],
          ),
        ),
      ],
    );
  }
}