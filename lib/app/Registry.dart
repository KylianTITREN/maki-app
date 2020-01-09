import 'package:c_valide/models/Magasin.dart';

class Registry {
  static List<Magasin> allShop;
  static String uid = '';
  static String chatUid = '';
  static Magasin magasin;
  static bool activeShop = true;
  static bool dialog;
  static DateTime lastMsg;
  static bool activeMessage;
  static int messageBadge = 0;
  static String comment = '';
  static String advisorText = '';
  static String folderNumber = '';
  static String oldState;
  static int folderValidated = 0;
  static Duration actualVideoDuration = Duration.zero;

  static void reset() {
    Registry.uid = '';
    Registry.dialog = true;
    Registry.comment = '';
    Registry.messageBadge = 0;
    Registry.advisorText = '';
    Registry.folderNumber = '';
    Registry.folderValidated = 0;
    Registry.actualVideoDuration = Duration.zero;
  }
}
