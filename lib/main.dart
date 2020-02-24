import 'package:maki_app/pages/splashscreen.dart';
import 'package:maki_app/res/Strings.dart';
import 'package:maki_app/res/Styles.dart';
import 'package:maki_app/utils/Cache.dart';
import 'package:maki_app/utils/NormalScrollBehavior.dart';
import 'package:maki_app/utils/System.dart';
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.appName,
        theme: Styles.defaultTheme,
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
      ),
    );
  }

  Widget getErrorWidget(BuildContext context, FlutterErrorDetails error) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/maki-sad.png',
                fit: BoxFit.contain,
                height: 80,
              ),
              SizedBox(height: 30),
              Text(
                'Oupsss.. J\'ai un chat dans la gorge',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
