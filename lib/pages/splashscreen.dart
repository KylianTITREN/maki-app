import 'dart:async';

import 'package:maki_app/pages/home.dart';
import 'package:maki_app/FlavorConfig.dart';
import 'package:maki_app/utils/Dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maki_app/utils/FirebaseUtils.dart';
import 'package:maki_app/utils/Page.dart';

class SplashscreenPage extends StatelessWidget {
  static get tag => '/splashscreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashscreenPageWidget(),
    );
  }
}

class SplashscreenPageWidget extends StatefulWidget {
  SplashscreenPageWidget({Key key}) : super(key: key);

  @override
  SplashscreenPageState createState() => SplashscreenPageState();
}

class SplashscreenPageState extends State<SplashscreenPageWidget>
    with WidgetsBindingObserver {
  FlavorConfig config;

  ChoicesDialog updateDialog;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void onResume() {
    FirebaseUtils.getVideos();
    FirebaseUtils.getRecettes();
    FirebaseUtils.getNames();
    FirebaseUtils.getDico();
    FirebaseUtils.getImagesLink();
    Timer.periodic(Duration(seconds: 1),
        (timer) => {fadePage(context, HomePage()), timer.cancel()});
  }

  @override
  Widget build(BuildContext context) {
    config = FlavorConfig.instance;

    onResume();

    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Image.asset(
          'assets/images/maki-shadow.png',
          width: MediaQuery.of(context).size.width * 0.4,
        ),
      ),
    );
  }
}
