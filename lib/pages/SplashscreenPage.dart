import 'package:c_valide/basics/BaseStatelessWidget.dart';
import 'package:c_valide/pages/StepsPage.dart';
import 'package:c_valide/res/HeroTags.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:flutter/material.dart';

class SplashscreenPage extends BaseStatelessWidget {
  static int _delay = 1500;
  int _requestsPending = 0;

  @override
  Widget onBuild() {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Center(
          child: Hero(
            tag: HeroTags.logo,
            child: Material(
              color: Colors.transparent,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.fitWidth,
                width: mq.size.width * 0.6,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onCreate() {
    _startTimer();
//    _startSharedPreferencesInitialization();
  }

  void _startTimer() {
    _requestsPending++;
    delay(() {
      _onRequestsFinished();
    }, _delay);
  }

//  void _startSharedPreferencesInitialization() {
//    _requestsPending++;
//    initializeSharedPreferences(() {
//      _onRequestsFinished();
//    });
//  }

  void _onRequestsFinished() {
    if (--_requestsPending == 0) {
      Page.replacePage(context, StepsPage());
    }
  }
}
