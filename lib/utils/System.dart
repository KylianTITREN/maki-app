import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class System {
  /// Status bar dark icons and transparent background
  static void transparentStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    );
  }
}
