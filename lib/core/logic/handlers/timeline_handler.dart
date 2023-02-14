import 'package:edirecte/core/logic/handlers/global_handler.dart';
import 'package:edirecte/core/utils/infos.dart';
import 'package:edirecte/core/utils/network.dart';
import 'package:edirecte/core/utils/network_utils.dart';
import 'package:edirecte/core/utils/logger.dart';

/* This class parses the timeline from EcoleDirecte
and saves it to the global infos */
class TimelineHandler {
  // Connection status //
  static bool gotTimeline = false;
  static bool isGettingTimeline = false;

  // Main function to parse the timeline from EcoleDirecte //
  static Future<void> getTimeline() async {
    if (Network.isConnecting || TimelineHandler.isGettingTimeline || !StoredInfos.isUserLoggedIn) return;

    // Begin getting timeline //
    TimelineHandler.gotTimeline = false;
    TimelineHandler.isGettingTimeline = true;
    GlobalHandler.isUpdated["timeline"] = false;

    Logger.printMessage("Getting timeline...");

    // Parse timeline //
    dynamic timelineResponse = await EcoleDirecteResponse.parse(
      EcoleDirectePath.timelineURL,
      {},
    );

    if (timelineResponse != null) {
      TimelineHandler.sortTimeline(timelineResponse);
      TimelineHandler.gotTimeline = true;
      GlobalHandler.setUpdated("timeline");

      Logger.printMessage("Got timeline !");
    }

    // Stop process //
    TimelineHandler.isGettingTimeline = false;
  }

  // Function to sort timeline objects and save them //
  static void sortTimeline(List timelineResponse) {
    // Reset all previously saved data //
    GlobalInfos.timelineEvents.clear();
    
    for (Map event in timelineResponse) {
      GlobalInfos.addTimelineEvent(event);
    }
  }

  // Function to erase all saved data //
  static void reset() {
    TimelineHandler.gotTimeline = false;
    TimelineHandler.isGettingTimeline = false;
    GlobalInfos.timelineEvents.clear();
  }
}


