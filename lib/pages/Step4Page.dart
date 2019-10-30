import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/basics/BaseState.dart';
import 'package:c_valide/basics/BaseStatefulWidget.dart';
import 'package:c_valide/components/AnomalieRow.dart';
import 'package:c_valide/components/BottomSheetComponent.dart';
import 'package:c_valide/components/CAnomalieDetails.dart';
import 'package:c_valide/components/CButton.dart';
import 'package:c_valide/components/CSeparator.dart';
import 'package:c_valide/components/CVideo.dart';
import 'package:c_valide/models/Anomalie.dart';
import 'package:c_valide/pages/StepsPage.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/res/HeroTags.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/res/Styles.dart';
import 'package:c_valide/utils/FirebaseUtils.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:flutter/material.dart';
import 'package:notifier/main_notifier.dart';
import 'package:sprintf/sprintf.dart';

class StepPage4 extends BaseStatefulWidget {
  StepPage4(this.parentState);

  final StepsPageState parentState;

  @override
  State<StatefulWidget> onBuild() => _StepPage4State();
}

class _StepPage4State extends BaseState<StepPage4> {
  List<Anomalie> _anomalies = [];

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
      child: Registry.folderValidated == 1
          ? Notifier.of(context).register<List<Anomalie>>(
              Strings.notifyAnomalies,
              (anomalies) {
                if (widget.parentState.currentState == 'CANCELED' && _anomalies != null && _anomalies.length <= 0) {
                  _anomalies = anomalies.hasData ? anomalies.data : [];
                }

                return _anomalies.length <= 0
                    ? Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: CircularProgressIndicator(),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  Strings.textValidating,
                                  style: Styles.text(context),
                                ),
                              ),
                              CSeparator(Colours.primaryColor),
                              Container(
                                margin: const EdgeInsets.only(top: 32.0),
                                child: CVideo(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    _anomalies.length == 1
                                        ? sprintf(
                                            Strings.textCanceledAnomalieFolderNumber,
                                            [Registry.folderNumber],
                                          )
                                        : sprintf(
                                            Strings.textCanceledAnomaliesFolderNumber,
                                            [Registry.folderNumber, _anomalies.length],
                                          ),
                                    style: Styles.text(context),
                                    textAlign: TextAlign.center,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                  CSeparator(Colours.primaryColor),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 8.0),
                                child: ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: _anomalies.length,
                                  itemBuilder: (context, index) {
                                    Anomalie anomalie = _anomalies[index];
                                    return GestureDetector(
                                      onTap: () {
                                        showModal(anomalie);
                                      },
                                      child: AnomalieRow(anomalie),
                                    );
                                  },
                                ),
                              ),
                              Notifier.of(context).register<String>(Strings.notifyComment, (response) {
                                print(response);
                                String comment =
                                    response.hasData ? response.data : (Registry.comment?.isNotEmpty ?? false ? Registry.comment : '');

                                return comment.isNotEmpty
                                    ? Column(
                                        children: <Widget>[
                                          SizedBox(height: 30),
                                          Text(
                                            'Merci de refaire signer le dossier',
                                            style: Styles.text(context),
                                            textAlign: TextAlign.center,
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              _onAdvisorCommentBtnPressed(comment);
                                            },
                                            child: Text(
                                              'Voir le commentaire du conseiller',
                                              style: Styles.littleTextPrimary(context),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container();
                              }),
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
                      );
              },
            )
          : Center(
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
                            Registry.folderValidated == 2 ? Strings.textFolderValidated : Strings.textFolderDeclined,
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
                            "assets/images/${Registry.folderValidated == 2 ? 'check' : 'cancel'}.png",
                            width: mq.size.width * 0.3,
                          ),
                        ),
                      ),
                    ),
                    Notifier.of(context).register<String>(Strings.notifyComment, (response) {
                      print(_anomalies);
                      String comment = response.hasData ? response.data : (Registry.comment?.isNotEmpty ?? false ? Registry.comment : '');

                      return comment.isNotEmpty
                          ? Column(
                              children: <Widget>[
                                SizedBox(height: 20),
                                FlatButton(
                                  onPressed: () {
                                    _onAdvisorCommentBtnPressed(comment);
                                  },
                                  child: Text(
                                    'Voir le commentaire du conseiller',
                                    style: Styles.littleTextPrimary(context),
                                  ),
                                ),
                              ],
                            )
                          : Container();
                    }),
                    Container(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: CButton(
                        Strings.textClose,
                        color: Colours.primaryColor,
                        onPressed: _onClose,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 32.0),
                      child: CVideo(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _onClose() {
    widget.parentState.restartStepsPage();

    // TODO Satisfaction a réactiver quand le WS sera bon
//    widget.parentState.onStepsOver(() {
//      delay(widget.parentState.restartStepsPage, 300);
//    });
  }

  void _onAdvisorCommentBtnPressed(String comment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Commentaire du conseiller',
                  textAlign: TextAlign.center,
                  style: Styles.appBarTitle(context),
                ),
                SizedBox(height: 8.0),
                Text(comment),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                quitDialog(context);
              },
              child: Text(Strings.textOk),
            ),
          ],
        );
      },
    );
  }

  void showModal(anomalie) async {
    int selectedId = await showModalBottomSheet<int>(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return BottomSheetComponent(
            barColor: Colors.black,
            backgroundColor: Colours.darkGrey,
            child: CAnomalieDetails(anomalie),
          );
        });

    if (selectedId == null) {
      setState(() {});
    }
  }
}
