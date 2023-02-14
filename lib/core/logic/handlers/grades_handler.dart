import 'package:edirecte/core/logic/handlers/global_handler.dart';
import 'package:edirecte/core/logic/objects/grades_obj.dart';
import 'package:edirecte/core/logic/objects/subject_obj.dart';

import 'package:edirecte/core/utils/infos.dart';
import 'package:edirecte/core/utils/network.dart';
import 'package:edirecte/core/utils/network_utils.dart';
import 'package:edirecte/core/utils/logger.dart';

/* This class stores all the grades and averages of the student
and parses the grades from EcoleDirecte */
class GradesHandler {
  // Current state of connection //
  static bool gotGrades = false;
  static bool isGettingGrades = false;

  // Main function to get the grades of the student //
  static Future<void> getGrades() async {
    if (Network.isConnecting || GradesHandler.isGettingGrades || !StoredInfos.isUserLoggedIn) return;

    // Begin getting grades //
    GradesHandler.gotGrades = false;
    GradesHandler.isGettingGrades = true;
    GlobalHandler.isUpdated["grades"] = false;

    Logger.printMessage("Getting grades...");

    // Parse grades //
    dynamic gradesResponse = await EcoleDirecteResponse.parse(
      EcoleDirectePath.gradesURL,
      {"anneeScolaire": ""},
    );

    if (gradesResponse != null) {
      GradesHandler.sortGrades(gradesResponse);
      GradesHandler.gotGrades = true;
      GlobalHandler.setUpdated("grades");

      Logger.printMessage("Got grades !");
    }

    // Stop process //
    GradesHandler.isGettingGrades = false;
  }

  // Function used to sort all grades and create objects for each //
  static void sortGrades(Map gradesResponse) {
    // Reset all previously saved grades //
    GradesHandler.reset();
    
    // Detect current period of the year //
    for (int i = 1; i <= 3; i++) {
      if (!gradesResponse["periodes"][(i - 1) * 3]["cloture"]) {
        GlobalInfos.currentPeriodIndex = i;
        break;
      }
    }

    // Create all subjects //
    for (Map subject in gradesResponse["periodes"][(GlobalInfos.currentPeriodIndex - 1) * 3]["ensembleMatieres"]["disciplines"]) {
      if (subject["codeMatiere"].isEmpty) continue;

      if (!GlobalInfos.subjects.containsKey(subject["codeMatiere"])) {
        GlobalInfos.addSubject(subjectCode: subject["codeMatiere"], subjectName: subject["discipline"], professorName: subject["professeurs"].length > 0 ? subject["professeurs"][0]["nom"] : "");
      }
    }

    // Sort grades by entered date //
    gradesResponse["notes"].sort((grade1, grade2) {
      DateTime grade1Date = DateTime.parse(grade1["dateSaisie"]);
      DateTime grade2Date = DateTime.parse(grade2["dateSaisie"]);
      return grade1Date.compareTo(grade2Date);
    });

    // Create all grade objects and add them to each subject //
    for (Map grade in gradesResponse["notes"]) {
      GlobalInfos.addGrade(jsonInfos: grade);
    }

    // Calculate all subject averages //
    for (Subject subject in GlobalInfos.subjects.values) {
      subject.calculateAverage();
    }

    // Calculate general average //
    GlobalInfos.generalAverage.calculateAverage(GlobalInfos.subjects);
  }

  // Function to reset all saved data //
  static void reset() {
    GradesHandler.gotGrades = false;
    GradesHandler.isGettingGrades = false;

    GlobalInfos.grades.clear();
    GlobalInfos.generalAverage = GeneralAverage();

    for (Subject subject in GlobalInfos.subjects.values) {
      subject.average.clear();
      subject.averageClass.clear();
      subject.grades.clear();
    }
  }
}

