class Registry {
  static String uid = '';
  static String folderNumber = '';
  static bool folderValidated = false;

  static void reset() {
    Registry.uid = '';
    Registry.folderNumber = '';
    Registry.folderValidated = false;
  }
}
