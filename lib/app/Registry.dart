class Registry {
  static String uid = '';
  static String comment = '';
  static String folderNumber = '';
  static bool folderValidated = false;
  static Duration actualVideoDuration = Duration.zero;

  static void reset() {
    Registry.uid = '';
    Registry.comment = '';
    Registry.folderNumber = '';
    Registry.folderValidated = false;
    Registry.actualVideoDuration = Duration.zero;
  }
}
