import 'package:c_valide/app/Const.dart';
import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/basics/BaseState.dart';
import 'package:c_valide/basics/BaseStatefulWidget.dart';
import 'package:c_valide/components/CButton.dart';
import 'package:c_valide/components/CSeparator.dart';
import 'package:c_valide/components/CVideo.dart';
import 'package:c_valide/pages/StepsPage.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/res/HeroTags.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/res/Styles.dart';
import 'package:c_valide/utils/FirebaseUtils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notifier/notifier.dart';

class StepPage2 extends BaseStatefulWidget {
  StepPage2(this.parentState);

  final StepsPageState parentState;

  @override
  State<StatefulWidget> onBuild() => _StepPage2State();
}

class _StepPage2State extends BaseState<StepPage2> {
  @override
  void onEnter() {
    super.onEnter();
    if (!kReleaseMode && Const.DEMO) {
      delay(() {
        FirebaseUtils.setFolderState(Registry.uid, 'IN_PROGRESS',
            callback: (uid) {
          widget.parentState.goToPage(2);
        });
      }, 6000);
    } else {
      widget.parentState.initSubscription();
    }
  }

  @override
  void onLeave() {
    super.onLeave();
    if (kReleaseMode || !Const.DEMO) {
      widget.parentState.cancelSubscription();
    }
  }

  @override
  Widget onBuild() {
    return Container(
      padding: const EdgeInsets.only(left:32.0,right:32,bottom:32),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Notifier.of(context).register<bool>(Strings.notifyNoAdvisor, (_) {
                return _.hasData && _.data
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CircularProgressIndicator(),
                      );
              }),
              Hero(
                tag: HeroTags.explanation,
                child: Material(
                  color: Colors.transparent,
                  child: Notifier.of(context)
                      .register<bool>(Strings.notifyNoAdvisor, (_) {
                    return Text(
                      _.hasData && _.data
                          ? '${Strings.textNoFreeAdvisor}. ${Strings.textServiceAvailableBetween}.'
                          : Strings.textWaitingForAdvisor,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: Styles.text(context),
                      softWrap: false,
                    );
                  }),
                ),
              ),
              Hero(
                tag: HeroTags.separator,
                child: CSeparator(Colours.primaryColor),
              ),
              Container(
                margin: const EdgeInsets.only(top: 32.0),
                child: CVideo(),
              ),
              Notifier.of(context).register<bool>(Strings.notifyNoAdvisor, (_) {
                return _.hasData && _.data
                    ? Container(
                        margin: const EdgeInsets.only(top: 32.0),
                        child: CButton(
                          Strings.textNewEntry,
                          color: Colours.primaryColor,
                          onPressed: () {
                            widget.parentState.goToFirstPage();
                          },
                        ),
                      )
                    : Container();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
