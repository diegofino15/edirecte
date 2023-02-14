import 'package:edirecte/core/logic/handlers/global_handler.dart';
import 'package:edirecte/core/logic/objects/homework_obj.dart';

import 'package:edirecte/core/utils/infos.dart';
import 'package:edirecte/core/utils/network.dart';
import 'package:edirecte/core/utils/network_utils.dart';
import 'package:edirecte/core/utils/logger.dart';

/* This class stores all the homeworks of the student
and parses the homeworks from EcoleDirecte */
class HomeworkHandler {
  // Current state of connection //
  static bool gotHomework = false;
  static bool isGettingHomework = false;

  // Main function to get the future homework of the student //
  static Future<void> getFutureHomework() async {
    if (Network.isConnecting || HomeworkHandler.isGettingHomework || !StoredInfos.isUserLoggedIn) return;

    // Begin getting grades //
    HomeworkHandler.gotHomework = false;
    HomeworkHandler.isGettingHomework = true;
    GlobalHandler.isUpdated["homework"] = false;

    Logger.printMessage("Getting homework...");
    
    // Parse homework //
    dynamic homeworkResponse = await EcoleDirecteResponse.parse(
      EcoleDirectePath.abstractHomeworkURL,
      {},
    );

    if (homeworkResponse != null) {
      HomeworkHandler.sortHomework(homeworkResponse);
      HomeworkHandler.gotHomework = true;
      GlobalHandler.setUpdated("homework");

      Logger.printMessage("Got homework !");
    }

    // Stop process //
    HomeworkHandler.isGettingHomework = false;
  }

  // Function used to sort all homework and create objects for each //
  static void sortHomework(Map homeworkResponse) {
    // Reset all previously saved data //
    GlobalInfos.homeworks.clear();
    
    for (String day in homeworkResponse.keys) {
      GlobalInfos.addHomeworkDay(homeworkDayStr: day, jsonInfos: homeworkResponse[day]);
    }
  }

  // Function to erase all saved data //
  static void reset() {
    HomeworkHandler.gotHomework = false;
    HomeworkHandler.isGettingHomework = false;
    GlobalInfos.homeworks.clear();
  }

  // Function to get the next homework of the student //
  static HomeworkDay? getNextHomework() {
    DateTime actualTime = DateTime.now();
    for (HomeworkDay homeworkDay in GlobalInfos.homeworks.values) {
      if (homeworkDay.day.toString().split(" ")[0] != actualTime.toString().split(" ")[0]) {
        return homeworkDay;
      }
    }

    return null;
  }
}