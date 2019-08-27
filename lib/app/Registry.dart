class Registry {
  static String uid = '';
  static String folderNumber = '';
  static bool folderValidated = false;
  static Duration actualVideoDuration = Duration.zero;

  static void reset() {
    Registry.uid = '';
    Registry.folderNumber = '';
    Registry.folderValidated = false;
    Registry.actualVideoDuration = Duration.zero;
  }
}
