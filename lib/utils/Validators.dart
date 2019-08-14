import 'package:c_valide/res/Strings.dart';

class Validators {
  static String text(val) {
    if (val.length == 0) {
      return Strings.warnFillThisField;
    }

    return null;
  }

  static String login(val) {
    if (val.length == 0) {
      return Strings.warnFillThisField;
    }

    return null;
  }

  static String password(val) {
    if (val.length == 0) {
      return Strings.warnFillThisField;
    }

    return null;
  }
}
