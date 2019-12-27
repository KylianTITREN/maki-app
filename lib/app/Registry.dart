class Registry {
  static String uid = '';
  static String comment = '';
  static String advisorText = '';
  static String folderNumber = '';
  static int folderValidated = 0;
  static Duration actualVideoDuration = Duration.zero;

  static void reset() {
    Registry.uid = '';
    Registry.comment = '';
    Registry.advisorText = '';
    Registry.folderNumber = '';
    Registry.folderValidated = 0;
    Registry.actualVideoDuration = Duration.zero;
  }
}
