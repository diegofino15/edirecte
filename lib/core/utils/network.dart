import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:edirecte/core/utils/file_handler.dart';
import 'package:edirecte/core/utils/network_utils.dart';
import 'package:edirecte/core/utils/infos.dart';
import 'package:edirecte/core/utils/logger.dart';

import 'package:edirecte/core/logic/handlers/global_handler.dart';

// This class contains all the methods needed to connect and parse data from EcoleDirecte //
class Network {
  // Current state of the connection //
  static bool isConnected = false;
  static bool isConnecting = false;

  // Main function to connect to EcoleDirecte //
  static Future<void> connect() async {
    if (Network.isConnecting) return;
    if (StoredInfos.loginUsername.isEmpty || StoredInfos.loginPassword.isEmpty) return;

    // Begin connection process //
    Network.isConnected = false;
    Network.isConnecting = true;

    Logger.printMessage("Connection...");

    Map<String, String> loginPayload = {
      "identifiant": StoredInfos.loginUsername,
      "motdepasse": StoredInfos.loginPassword,
    };

    try {
      // Try to login //
      http.Response encodedLoginResponse = await http.post(
        Uri.parse(EcoleDirectePath.loginUrl),
        body: EcoleDirectePath.transformPayload(loginPayload),
      );

      // Decode the response //
      Map loginResponse = jsonDecode(utf8.decode(encodedLoginResponse.bodyBytes));

      // Check if request was successful //
      if (loginResponse["code"] == EcoleDirecteResponse.success) {
        // Save the connection token //
        EcoleDirectePath.connectionToken = loginResponse["token"];

        // Save all login data //
        Infos.saveLoginData(loginResponse["data"]["accounts"][0]);

        // Save to local storage //
        await FileHandler.instance.changeInfos({
          "username": StoredInfos.loginUsername,
          "password": StoredInfos.loginPassword,
          "isUserLoggedIn": true
        });

        // Confirm connection status //
        Network.isConnected = true;
        StoredInfos.isUserLoggedIn = true;

        // Parse all informations //
        Network.isConnecting = false;
        GlobalHandler.loadEverything(connect: false);

        Logger.printMessage("Successfully connected !");
      } else {
        // If request was not successful, disconnect the user //
        StoredInfos.isUserLoggedIn = false;

        Logger.printMessage("Connection failed");
      }

    } catch (e) {
      Logger.printMessage("An error occured when connecting...");
      Logger.printMessage("Error : $e");
    }

    // Finish connection process //
    Network.isConnecting = false;
  }

  // Function to disconnect and forget all saved data //
  static Future<void> disconnect() async {
    Network.isConnected = false;

    // Reset stored informations //
    FileHandler.instance.writeInfos({});

    StoredInfos.isUserLoggedIn = false;
    StoredInfos.loginUsername = "";
    StoredInfos.loginPassword = "";
    StoredInfos.guessGradeCoefficient = true;
    StoredInfos.subjectCoefficient = true;

    // Reset all saved informations //
    GlobalHandler.eraseEverything();
  }
}

