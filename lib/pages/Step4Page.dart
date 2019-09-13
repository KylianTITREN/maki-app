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
import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class StepPage4 extends BaseStatefulWidget {
  StepPage4(this.parentState);

  final StepsPageState parentState;

  @override
  State<StatefulWidget> onBuild() => _StepPage4State();
}

class _StepPage4State extends BaseState<StepPage4> {
  @override
  void onEnter() {
    super.onEnter();
    widget.parentState.initSubscription();
  }

  @override
  void onLeave() {
    super.onLeave();
    widget.parentState.cancelSubscription();
  }

  @override
  Widget onBuild() {
    FirebaseUtils.deleteFolder(Registry.uid);

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
                    sprintf(
                      Registry.folderValidated
                          ? Strings.textFolderValidated
                          : Strings.textFolderDeclined,
                      [Registry.folderNumber],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
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
              Container(
                margin: EdgeInsets.only(top: 24.0),
                child: Hero(
                  tag: HeroTags.textField,
                  child: Material(
                    color: Colors.transparent,
                    child: Image.asset(
                      "assets/images/${Registry.folderValidated ? 'check' : 'cancel'}.png",
                      width: mq.size.width * 0.3,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 32.0),
                child: CVideo(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 32.0),
                child: CButton(
                  Strings.textClose,
                  color: Colours.primaryColor,
                  onPressed: _onClose,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onClose() {
    Registry.reset();

    widget.parentState.goToFirstPage();
  }
}
