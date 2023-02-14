import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:gap/gap.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

import 'package:edirecte/ui/styles.dart';
import 'package:edirecte/ui/widgets/box_widget.dart';
import 'package:edirecte/ui/widgets/connection_status.dart';
import 'package:edirecte/ui/widgets/bottom_sheet.dart';
import 'package:edirecte/ui/widgets/input.dart';

import 'package:edirecte/core/utils/infos.dart';
import 'package:edirecte/core/utils/network.dart';
import 'package:edirecte/core/utils/auth_service.dart';
import 'package:edirecte/core/utils/file_handler.dart';
import 'package:edirecte/core/utils/logger.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Only update the page if it's mounted //
  @override
  void setState(VoidCallback fn) { if (mounted) super.setState(fn); }

  // This function updates the screen when it needs to //
  Future<void> _updateScreen() async {
    while (mounted) {
      while (Network.isConnecting) {
        await Future.delayed(const Duration(milliseconds: 500));
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
    showPassword = false;
    if (StoredInfos.isUserLoggedIn) {
      setState(() => {
        Network.connect().then((value) => setState(() {}))
      });
    }
  }

  // Function called when the user tries to connect //
  Future<void> _handleConnect() async {
    showPassword = false;

    CustomBottomSheet.show(
      context,
      625.0,
      [
        const Text("Se connecter", style: EDirecteStyles.pageTitleTextStyle),
        const Gap(10.0),
        const Text("Connectez vous avec vos identifiants EcoleDirecte.", style: EDirecteStyles.itemTextStyle),
        const Gap(20.0),
        Input(
          placeholder: "Identifiant",
          initialValue: StoredInfos.loginUsername,
          hideText: false,
          changeValueFunction: (value) => {StoredInfos.loginUsername = value},
          submitFunction: (value) => {},
        ),
        const Gap(10.0),
        Input(
          placeholder: "Mot de passe",
          hideText: true,
          changeValueFunction: (value) => {StoredInfos.loginPassword = value},
          submitFunction: (value) => setState(() {
            Network.connect().then((value) => setState(() {
              if (!StoredInfos.isUserLoggedIn) {
                _handleConnect();
              }
            }));
            Navigator.pop(context);
          }),
        ),
        const Gap(20.0),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 60.0,
          child: MaterialButton(
            onPressed: () => setState(() {
              Network.connect().then((value) => setState(() {
                if (!StoredInfos.isUserLoggedIn) {
                  _handleConnect();
                }
              }));
              Navigator.pop(context);
            }),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            color: Colors.green,
            child: Text("Se connecter", style: EDirecteStyles.sectionTitleTextStyle.copyWith(color: Colors.white)),
          ),
        ),
        const Gap(20.0),
        BoxWidget(
          isSecondColor: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Ce que nous faisons avec vos informations", style: EDirecteStyles.itemTitleTextStyle),
              Gap(10.0),
              Text("Votre identifiant et mot de passe sont enregistrés et chiffrés afin de vous reconnecter automatiquement.", style: EDirecteStyles.itemTextStyle),
              Text("Nous n'avons aucun accès à vos informations.", style: EDirecteStyles.itemTextStyle),
            ],
          ),
        ),
        const Gap(20.0),
        GestureDetector(
          onTap: () async {
            if (await canLaunchUrl(Uri.parse("https://www.ecoledirecte.com/"))) {
              await launchUrl(Uri.parse("https://www.ecoledirecte.com/"));
            } else {
              Logger.printMessage("Unable to launch URL");
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 60.0,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Site officiel EcoleDirecte", style: EDirecteStyles.itemTextStyle.copyWith(color: Colors.white)),
                const Icon(FeatherIcons.logOut, size: 25.0, color: Colors.white)
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Function called when the user tries to disconnect //
  Future<void> _handleDisconnect() async {
    showPassword = false;
    CustomBottomSheet.show(
      context,
      180.0,
      [
        const Text("Se déconnecter ?", style: EDirecteStyles.pageTitleTextStyle),
        const Gap(10.0),
        const Text("Voulez-vous vraiment vous déconnecter ? Vos identifiants de connexion seront oubliés.", style: EDirecteStyles.itemTextStyle),
        const Gap(10.0),
        OutlinedButton(
          onPressed: () => setState(() {
            Network.disconnect().then((value) => setState(() => {}));
            Navigator.pop(context);
          }),
          child: Text("Confirmer", style: EDirecteStyles.itemTextStyle.copyWith(color: Colors.red)),
        ),
      ],
    );
  }

  // Function called when the user wants to know more about experimental features //
  void _handleExperimentalFeatures() {
    CustomBottomSheet.show(
      context,
      270,
      [
        const Text("Devine coefficient notes", style: EDirecteStyles.sectionTitleTextStyle),
        const Gap(10.0),
        const Text("EcoleDirecte cache les coefficients individuel des notes, cela peut donner lieu à des moyennes inexactes. Cette fonction permet de deviner le coefficient d'une note grâce à son titre, elle peut se tromper. Les résultats peuvent toujours être inexacts.", style: EDirecteStyles.itemTextStyle),
        const Gap(20.0),
        const Text("Paramètres", style: EDirecteStyles.itemTitleTextStyle),
        const Gap(10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("DST : 2", style: EDirecteStyles.itemTextStyle),
            Text("-", style: EDirecteStyles.itemTextStyle),
            Text("DM : 0,5", style: EDirecteStyles.itemTextStyle),
            Text("-", style: EDirecteStyles.itemTextStyle),
            Text("Autre : 1", style: EDirecteStyles.itemTextStyle),
          ],
        ),
      ],
    );
  }

  // If the password should be shown or not to the user //
  bool showPassword = false;

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
                const Text("Profil", style: EDirecteStyles.pageTitleTextStyle),
                ConnectionStatus(isChecked: Network.isConnected, isBeingChecked: Network.isConnecting),
              ],
            ),
          ),
          const Gap(20.0),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Network.isConnecting ? Colors.blue : Network.isConnected ? Colors.green : Colors.red,
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Text(Network.isConnecting ? "Connexion..." : Network.isConnected ? "Vous êtes connecté${Infos.studentGender == "M" ? "" : "e"} !" : "Vous n'êtes pas connecté", style: EDirecteStyles.sectionTitleTextStyle.copyWith(color: Colors.white)),
          ),
          const Gap(20.0),
          Network.isConnecting
            ? Container()
            : BoxWidget(
                child: Network.isConnected ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Network.isConnected ? Infos.studentFullName : "--", style: EDirecteStyles.itemTitleTextStyle),
                        const Gap(5.0),
                        Text(Network.isConnected ? Infos.studentClass : "-", style: EDirecteStyles.itemTextStyle)
                      ],
                    ),
                    SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: MaterialButton(
                        onPressed: _handleDisconnect,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        color: Colors.red,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(FeatherIcons.logOut, size: 20.0, color: Colors.white)]),
                      ),
                    ),
                  ],
                ) : Center(
                  child: GestureDetector(
                    onTap: _handleConnect,
                    child: Text("Se connecter", style: EDirecteStyles.sectionTitleTextStyle.copyWith(color: Colors.blue)),
                  ),
                )
              ),
          const Gap(20.0),
          Network.isConnected
            ? BoxWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [const Text("Identifiant : ", style: EDirecteStyles.itemTextStyle), Text(StoredInfos.loginUsername, style: EDirecteStyles.itemTextStyle.copyWith(color: Colors.black))]),
                    const Gap(10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text("Mot de passe : ", style: EDirecteStyles.itemTextStyle),
                            showPassword
                              ? SelectableText(StoredInfos.loginPassword, style: EDirecteStyles.itemTextStyle.copyWith(color: Colors.black))
                              : Row(
                                  children: List.generate(StoredInfos.loginPassword.length, (index) {
                                    return Container(
                                      width: 5.0,
                                      height: 5.0,
                                      margin: const EdgeInsets.only(right: 1.0),
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(Radius.circular(2.5)),
                                      ),
                                    );
                                  }),
                                ),
                          ]
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            if (!showPassword) {
                              AuthService.authenticateUser().then((value) => setState(() => {
                                if (value) showPassword = true
                              }));
                            } else {
                              showPassword = !showPassword;
                            }
                          }),
                          child: Icon(showPassword ? FluentIcons.eye_24_regular : FluentIcons.eye_off_24_regular),
                        ),
                      ],
                    ),
                    const Gap(10.0),
                    Row(children: [const Text("Numéro tel : ", style: EDirecteStyles.itemTextStyle), Text(Infos.studentPhoneNumber.replaceAll("-", " "), style: EDirecteStyles.itemTextStyle.copyWith(color: Colors.black))]),
                    const Gap(10.0),
                    Row(children: [const Text("Email : ", style: EDirecteStyles.itemTextStyle), Text(Infos.studentEmail, style: EDirecteStyles.itemTextStyle.copyWith(color: Colors.black))]),
                  ],
                ),
              )
            : Container(),
          const Gap(20.0),
          Network.isConnected
            ? BoxWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Béta", style: EDirecteStyles.sectionTitleTextStyle),
                  const Gap(10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Coefficients matières (2nde)", style: EDirecteStyles.itemTextStyle),

                      GestureDetector(
                        onTap: () => setState(() {
                          StoredInfos.subjectCoefficient = !StoredInfos.subjectCoefficient;
                          FileHandler.instance.changeInfos({"subject_coefficient": StoredInfos.subjectCoefficient});
                        }),
                        child: Icon(StoredInfos.subjectCoefficient ? FluentIcons.checkbox_checked_24_filled : FluentIcons.checkbox_unchecked_24_regular)
                      ),
                    ],
                  ),
                  const Gap(10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Devine coefficient notes", style: EDirecteStyles.itemTextStyle),
                      GestureDetector(
                        onTap: _handleExperimentalFeatures,
                        child: const Icon(FluentIcons.info_24_regular, size: 20.0, color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          StoredInfos.guessGradeCoefficient = !StoredInfos.guessGradeCoefficient;
                          FileHandler.instance.changeInfos({"guess_grade_coefficient": StoredInfos.guessGradeCoefficient});
                        }),
                        child: Icon(StoredInfos.guessGradeCoefficient ? FluentIcons.checkbox_checked_24_filled : FluentIcons.checkbox_unchecked_24_regular)
                      ),
                    ],
                  ),
                ],
              ),
            )
            : Container(),
        ],
      ),
    );
  }
}
