import 'package:edirecte/core/logic/handlers/grades_handler.dart';
import 'package:edirecte/core/logic/handlers/homework_handler.dart';
import 'package:edirecte/core/logic/handlers/schedule_handler.dart';
import 'package:edirecte/core/logic/handlers/timeline_handler.dart';

import 'package:edirecte/core/utils/file_handler.dart';
import 'package:edirecte/core/utils/infos.dart';
import 'package:edirecte/core/utils/network.dart';

/* This class is the global handler, it loads everything up
at the launching of the app */
class GlobalHandler {
  // Current state of connection //
  static bool isEverythingUpdated() {
    bool isEverythingUpdated_ = true;
    for (MapEntry<String, bool> isHandlerUpdated in GlobalHandler.isUpdated.entries) {
      isEverythingUpdated_ = isEverythingUpdated_ && isHandlerUpdated.value;
      if (!isEverythingUpdated_) {
        // print("Found thing not updated : ${isHandlerUpdated.key}");
        return false;
      }
    }
    return true;
  }

  // Main function to load everything up //
  static Future<void> loadEverything({bool connect = false}) async {
    GlobalHandler.eraseEverything();
    
    for (String key in GlobalHandler.isUpdated.keys) { GlobalHandler.isUpdated[key] = false; }
    
    if (connect) {
      Map infos = await FileHandler.instance.readInfos();
      if (infos.isNotEmpty) {
        StoredInfos.isUserLoggedIn = infos["isUserLoggedIn"] ?? false;
        StoredInfos.loginUsername = infos["username"] ?? "";
        StoredInfos.loginPassword = infos["password"] ?? "";

        StoredInfos.guessGradeCoefficient = infos["guess_grade_coefficient"] ?? true;
        StoredInfos.subjectCoefficient = infos["subject_coefficient"] ?? true;
      } else {
        await FileHandler.instance.writeInfos(StoredInfos.savedInfos);
      }
    }
    
    if (StoredInfos.isUserLoggedIn || !connect) {
      if (connect) { await Network.connect(); }

      TimelineHandler.getTimeline();
      GradesHandler.getGrades();
      HomeworkHandler.getFutureHomework();
      ScheduleHandler.getSchedule();
    }
  }

  // Main function to erase all saved data //
  static void eraseEverything() {
    GlobalInfos.subjects.clear();
    GlobalInfos.updateActualDay();
    
    TimelineHandler.reset();
    GradesHandler.reset();
    HomeworkHandler.reset();
    ScheduleHandler.reset();
  }

  static Map<String, bool> isUpdated = {
    "timeline": false,
    "grades": false,
    "homework": false,
    "schedule": false
  };

  static void setUpdated(String id) {
    GlobalHandler.isUpdated[id] = true;
  }
}


