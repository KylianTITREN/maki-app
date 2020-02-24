import 'package:c_valide/pages/SplashscreenPage.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/utils/Cache.dart';
import 'package:c_valide/utils/NormalScrollBehavior.dart';
import 'package:c_valide/utils/System.dart';
import 'package:flutter/material.dart';
import 'package:notifier/notifier.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return getErrorWidget(context, errorDetails);
    };

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
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return getErrorWidget(context, errorDetails);
        };

        return NotifierProvider(
          child: ScrollConfiguration(
            behavior: NormalScrollBehavior(),
            child: child,
          ),
        );
      },
    );
  }

  Widget getErrorWidget(BuildContext context, FlutterErrorDetails error) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/alarm-error.png',
                fit: BoxFit.contain,
                height: 80,
                color: Colours.primaryColor,
              ),
              SizedBox(height: 30),
              Text(
                'Une erreur est survenue, veuillez redémarrer l’application.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
