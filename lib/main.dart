import 'package:c_valide/pages/SplashscreenPage.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/utils/Cache.dart';
import 'package:c_valide/utils/NormalScrollBehavior.dart';
import 'package:c_valide/utils/System.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    System.transparentStatusBar();

    initializeSharedPreferences();

    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        primarySwatch: Colours.primaryColor,
        cursorColor: Colours.primaryColor,
      ),
      home: SplashscreenPage(),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: NormalScrollBehavior(),
          child: child,
        );
      },
    );
  }
}
