import 'package:flutter/material.dart';

class Misc {
  static isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }
}
