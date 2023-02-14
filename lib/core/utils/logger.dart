class Logger {
  static const bool isInDebugMode = false;

  static void printMessage(String mess) {
    if (isInDebugMode) {
      // ignore: avoid_print
      print(mess);
    }
  }
}