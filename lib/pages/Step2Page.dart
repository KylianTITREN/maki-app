import 'dart:async';

import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/basics/BaseState.dart';
import 'package:c_valide/basics/BaseStatefulWidget.dart';
import 'package:c_valide/components/CSeparator.dart';
import 'package:c_valide/components/CVideo.dart';
import 'package:c_valide/pages/StepsPage.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/res/HeroTags.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/res/Styles.dart';
import 'package:c_valide/utils/FirebaseUtils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class StepPage2 extends BaseStatefulWidget {
  StepPage2(this.parentState);

  final StepsPageState parentState;

  @override
  State<StatefulWidget> onBuild() => _StepPage2State();
}

class _StepPage2State extends BaseState<StepPage2> {
  StreamSubscription<Event> _subscription;

  @override
  void onCreate() {
    _subscription = FirebaseUtils.listenState(
      Registry.uid,
      ['IN_PROGRESS'],
      callback: (state) {
        switch (state) {
          case 'IN_PROGRESS':
            {
              _goToNextPage();
              break;
            }
        }
      },
    );
  }

  @override
  Widget onBuild() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Hero(
                tag: HeroTags.explanation,
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    Strings.textWaitingForAdvisor,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: Styles.text(context),
                    softWrap: false,
                  ),
                ),
              ),
              Hero(
                tag: HeroTags.separator,
                child: CSeparator(Colours.primaryColor),
              ),
              CVideo(),
            ],
          ),
        ),
      ),
    );
  }

  void _goToNextPage() {
    if (_subscription != null) {
      _subscription.cancel();
    }

    widget.parentState.goToNextPage();
  }
}
