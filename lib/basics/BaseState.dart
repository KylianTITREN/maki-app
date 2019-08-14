import 'package:c_valide/utils/Page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  BuildContext context;
  MediaQueryData mq;

  void onCreate() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  Widget onBuild();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    this.mq = MediaQuery.of(context);
    onCreate();

    return onBuild();
  }

  delay(VoidCallback callback, int duration) {
    Page.delay(callback, duration);
  }
}
