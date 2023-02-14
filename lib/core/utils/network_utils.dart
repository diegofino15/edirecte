import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:edirecte/core/utils/network.dart';
import 'package:edirecte/core/utils/infos.dart';
import 'package:edirecte/core/utils/logger.dart';

// This class contains all paths needed to parse data from EcoleDirecte //
class EcoleDirectePath {
  // Connection token needed to parse data //
  static String connectionToken = "";

  // Base API url //
  static const String baseUrl = "https://api.ecoledirecte.com/v3";

  // Url needed to login //
  static const String loginUrl = "$baseUrl/login.awp";

  // Url to parse the student's timeline //
  static String get timelineURL => "$baseUrl/eleves/${Infos.studentID}/timeline.awp?verbe=get";

  // Url to parse the student's grades //
  static String get gradesURL => "$baseUrl/eleves/${Infos.studentID}/notes.awp?verbe=get";

  // Url to parse the student's schedule //
  static String get scheduleURL => "$baseUrl/E/${Infos.studentID}/emploidutemps.awp?verbe=get";

  // Urls to get the abstract homework, get the specific homework, and change the state of the homework //
  static String get abstractHomeworkURL => "$baseUrl/Eleves/${Infos.studentID}/cahierdetexte.awp?verbe=get";
  static String specificHomeworkURL(String day) => "$baseUrl/Eleves/${Infos.studentID}/cahierdetexte/$day.awp?verbe=get";
  static String get changeHomeworkStateURL => "$baseUrl/Eleves/${Infos.studentID}/cahierdetexte.awp?verbe=put";

  // Url to parse the student's mails //
  static String get mailsURL => "$baseUrl/eleves/${Infos.studentID}/messages.awp?force=true&typeRecuperation=received&idClasseur=0&orderBy=date&order=desc&query=&onlyRead=&page=0&itemsPerPage=100&getAll=0&verbe=get";
  static String specificMailURL(int id) => "$baseUrl/eleves/${Infos.studentID}/messages/$id.awp?verbe=get&mode=destinataire";

  // Function to create an EcoleDirecte appropriate payload //
  static String transformPayload(Map payload) => "data=${jsonEncode(payload)}";
}

// This class contains all the possible responses from EcoleDirecte when parsing data //
class EcoleDirecteResponse {
  static const int success = 200;
  static const int failed = 505;

  static const int invalidToken = 520;
  static const int outdatedToken = 525;

  // Main function to parse data from EcoleDirecte //
  static Future<dynamic> parse(String url, Map payload) async {
    try {
      http.Response encodedResponse = await http.post(
        Uri.parse(url),
        body: EcoleDirectePath.transformPayload(payload),
        headers: {"x-token": EcoleDirectePath.connectionToken},
        encoding: utf8,
      );

      // Decode the response //
      Map response = jsonDecode(utf8.decode(encodedResponse.bodyBytes));

      // Check if request was successful //
      if (response["code"] == EcoleDirecteResponse.success) {
        return response["data"];
      } else if (response["code"] == EcoleDirecteResponse.outdatedToken) {
        Logger.printMessage("Outdated token, reconnecting....");
        await Network.connect();
        return EcoleDirecteResponse.parse(url, payload);
      }
    } catch (e) {
      Logger.printMessage("An error occured when connecting to $url");
      Logger.printMessage("Error : $e");
    }
  }
}


