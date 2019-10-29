import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver {
  BuildContext context;
  MediaQueryData mq;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
//    onEnter();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    onLeave();
    super.dispose();
  }

  void onCreate() {
    onEnter();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  void onEnter() {}

  void onLeave() {}

  void onResume() {}

  void onPause() {}

  void onInactive() {}

  void onSuspend() {}

  Widget onBuild();

  @override
  Widget build(BuildContext context) {
    this.context = context;
    this.mq = MediaQuery.of(context);
    onCreate();

    return onBuild();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        onEnter();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.suspending:
        onSuspend();
        break;
      case AppLifecycleState.paused:
        onPause();
        onLeave();
        break;
    }
  }

  delay(VoidCallback callback, int duration) {
    delay(callback, duration);
  }
}
