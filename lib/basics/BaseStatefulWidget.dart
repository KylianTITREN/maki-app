import 'package:c_valide/utils/Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  void onCreate() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  State onBuild();

  @override
  State createState() {
    onCreate();

    return onBuild();
  }

  void delay(VoidCallback callback, int duration) {
    Page.delay(callback, duration);
  }
}
