import 'package:edirecte/core/logic/handlers/global_handler.dart';
import 'package:edirecte/core/logic/objects/schedule_obj.dart';

import 'package:edirecte/core/utils/infos.dart';
import 'package:edirecte/core/utils/network.dart';
import 'package:edirecte/core/utils/network_utils.dart';
import 'package:edirecte/core/utils/logger.dart';

/* This class stores all the student's schedules day by day
and parses them from EcoleDirecte if needed */
class ScheduleHandler {
  // List of all the days loaded //
  static List<String> loadedDays = [];

  // Current state of connection //
  static bool gotSchedule = false;
  static bool isGettingSchedule = false;
  static Map<String, bool> isGettingSpecificDay = {};

  // Main function to get the schedules of the student //
  static Future<void> getSchedule({int daysMoreAndLeft = 10, bool eraseAll = true}) async {
    if (Network.isConnecting || !StoredInfos.isUserLoggedIn) return;

    // Begin getting schedule //
    ScheduleHandler.gotSchedule = false;
    ScheduleHandler.isGettingSchedule = true;
    GlobalHandler.isUpdated["schedule"] = false;

    Logger.printMessage("Getting schedule...");

    // Parse grades //
    dynamic scheduleResponse = await EcoleDirecteResponse.parse(
      EcoleDirectePath.scheduleURL,
      {
        "dateDebut": GlobalInfos.actualDay.add(Duration(days: -daysMoreAndLeft)).toString().split(" ")[0],
        "dateFin": GlobalInfos.actualDay.add(Duration(days: daysMoreAndLeft)).toString().split(" ")[0],
        "avecTrous": false
      },
    );

    if (scheduleResponse != null) {
      if (eraseAll) ScheduleHandler.reset();

      for (int i = -daysMoreAndLeft; i <= daysMoreAndLeft; i++) {
        String dayStr = GlobalInfos.actualDay.add(Duration(days: i)).toString().split(" ")[0];
        ScheduleHandler.loadedDays.add(dayStr);
      }

      ScheduleHandler.sortSchedule(scheduleResponse);
      ScheduleHandler.gotSchedule = true;
      GlobalHandler.setUpdated("schedule");

      Logger.printMessage("Got schedule !");
    }

    // Stop process //
    ScheduleHandler.isGettingSchedule = false;
  }

  // Function used to sort all classes day by day from EcoleDirecte's response //
  static void sortSchedule(List scheduleResponse) {
    // Create all scheduled classes objects //
    for (Map scheduledClass in scheduleResponse) {
      ScheduledClass scheduledClassObj = GlobalInfos.addScheduledClass(jsonInfos: scheduledClass);

      // Add class to loaded days //
      ScheduleHandler.loadedDays.add(scheduledClassObj.day);
    }

    // Sort all classes by hour on each day //
    GlobalInfos.sortScheduledClasses();
  }

  // Function to reset all saved data //
  static void reset() {
    ScheduleHandler.gotSchedule = false;
    ScheduleHandler.isGettingSchedule = false;
    ScheduleHandler.loadedDays.clear();
    GlobalInfos.scheduledClasses.clear();
  }

  // Next class //
  static DateTime nextClassTime = DateTime.now();
  static Duration get timeBeforeNextClass => nextClassTime.difference(DateTime.now());

  // Function to get the next scheduled class //
  static List<ScheduledClass>? getNextScheduledClass() {
    DateTime actualTime = DateTime.now();
    String actualDay = actualTime.toString().split(" ")[0];

    if (GlobalInfos.scheduledClasses.containsKey(actualDay)) {
      for (String hour in GlobalInfos.scheduledClasses[actualDay]!.keys) {
        DateTime dateAndHour = DateTime.parse("$actualDay $hour");
        if (dateAndHour.compareTo(actualTime) >= 0) {
          nextClassTime = dateAndHour;
          return GlobalInfos.scheduledClasses[actualDay]![hour]!;
        }
      }
    }

    const int dayToSee = 3;
    for (int i = 1; i < dayToSee; i++) {
      DateTime nextDay = actualTime.add(Duration(days: i));
      String nextDayStr = nextDay.toString().split(" ")[0];
      if (GlobalInfos.scheduledClasses.containsKey(nextDayStr)) {
        String key = GlobalInfos.scheduledClasses[nextDayStr]!.keys.first;
        nextClassTime = DateTime.parse("$nextDayStr $key");
        return GlobalInfos.scheduledClasses[nextDayStr]![key]!;
      }
    }

    return null;
  }
}



