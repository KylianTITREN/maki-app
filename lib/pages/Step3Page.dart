import 'dart:async';
import 'dart:ui';

import 'package:c_valide/api/RestClient.dart';
import 'package:c_valide/app/Const.dart';
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
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/res/Styles.dart';
import 'package:c_valide/utils/DialogUtils.dart';
import 'package:c_valide/utils/FirebaseUtils.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notifier/main_notifier.dart';
import 'package:sprintf/sprintf.dart';

class StepPage3 extends BaseStatefulWidget {
  StepPage3(this.parentState);

  final StepsPageState parentState;

  @override
  State<StatefulWidget> onBuild() => _StepPage3State();
}

class _StepPage3State extends BaseState<StepPage3> with WidgetsBindingObserver {
  List<Anomalie> _anomalies = [];

  int requestsPending = 0;
  int requestDialog = 0;

  @override
  void onEnter() {
    super.onEnter();
    widget.parentState.initSubscription();
    Timer.periodic(Duration(seconds: 2), (timer) {
      if(widget.parentState.currentState == 'ANOMALIES' && requestDialog == 0){
        requestDialog = 1;
        _onAdvisorCommentBtnPressed(Registry.comment, _anomalies);
        timer.cancel();
      }
    });
//    if (widget.parentState.currentStep == 2 && _anomalies.length <= 0) {
//      if (Const.DEMO) {
//        delay(() {
//          _startAnomaliesRequest();
//        }, 10000);
//      } else {
//      widget.parentState.initSubscription();
//
//        if (widget.parentState.currentState == 'ANOMALIES') {
//          _startAnomaliesRequest();
//        }
//      }
//    }
  }

  @override
  void onLeave() {
    super.onLeave();
    widget.parentState.cancelSubscription();
  }

  @override
  Widget onBuild() {
    print(widget.parentState.currentState);
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Notifier.of(context).register<List<Anomalie>>(
        Strings.notifyAnomalies,
        (anomalies) {
          if (widget.parentState.currentState == 'ANOMALIES' &&
              _anomalies != null &&
              _anomalies.length <= 0) {
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
                                      Strings.textAnomalieFolderNumber,
                                      [Registry.folderNumber],
                                    )
                                  : sprintf(
                                      Strings.textAnomaliesFolderNumber,
                                      [
                                        Registry.folderNumber,
                                        _anomalies.length
                                      ],
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
                        listOfAnomalies(_anomalies, true),
                        Notifier.of(context).register<String>(
                            Strings.notifyComment, (response) {
                          String comment = response.hasData
                              ? response.data
                              : (Registry.comment?.isNotEmpty ?? false
                                  ? Registry.comment
                                  : '');

                          return comment.isNotEmpty
                              ? Column(
                                  children: [
                                    // SizedBox(height: 20),
                                    // Text(
                                    //   Strings.textAdvisorComment,
                                    //   style: Styles.subtitle(context),
                                    // ),
                                    SizedBox(height: 20),
                                    CButton(
                                      'Voir le commentaire du conseiller',
                                      color: Colours.grey,
                                      onPressed: () {
                                        _onAdvisorCommentBtnPressed(
                                            comment, _anomalies);
                                      },
                                    ),
                                    // Column(
                                    //   children: [
                                    //     Text(
                                    //       comment.length > 200
                                    //           ? comment.substring(0, 200) +
                                    //               "..."
                                    //           : comment,
                                    //       style: TextStyle(color: Colors.white),
                                    //     ),
                                    //     FlatButton(
                                    //       onPressed: () {
                                    //         _onAdvisorCommentBtnPressed(
                                    //             comment, _anomalies);
                                    //       },
                                    //       child: Text(
                                    //         Strings.textSeeMore,
                                    //         style: Styles.littleTextPrimary(
                                    //             context),
                                    //       ),
                                    //     )
                                    //   ],
                                    // ),
                                    SizedBox(height: 20),
                                  ],
                                )
                              : Container();
                        }),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: CButton(
                            Strings.textAskNewStudy,
                            color: Colours.primaryColor,
                            onPressed: () {
                              _onValidate();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  void _onAdvisorCommentBtnPressed(String comment, List<Anomalie> anomalies) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                anomalies.length > 0 ? Text(
                  'Anomalie(s)',
                  textAlign: TextAlign.left,
                  style: Styles.appBarTitle(context),
                ) : Container(),
                SizedBox(height: 15.0),
                listOfAnomalies(anomalies, false),
                SizedBox(height: 15.0),
                Text(
                  Strings.textAdvisorComment,
                  textAlign: TextAlign.left,
                  style: Styles.appBarTitle(context),
                ),
                SizedBox(height: 15.0),
                Text(
                  comment,
                  style: TextStyle(fontSize: 14, color: Colours.grey),
                ),
                SizedBox(height: 40.0),
                Text(
                  Registry.advisorText,
                ),
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

  void _onValidate() {
    if (_anomalies.every((anomalie) => anomalie.isResolved)) {
      _sendDocuments();
    } else {
      toast(Strings.textUploadDocumentsPlease);
    }
    if (_anomalies.every((anomalie) => !anomalie.pictureNeeded)) {
      _sendDocuments();
    }
  }

  void _sendDocuments() {
    DialogUtils.showLoading(context, text: Strings.textLoading);

    if (!kReleaseMode && Const.DEMO) {
      delay(() {
        FirebaseUtils.setFolderState(Registry.uid, 'VALIDATED',
            callback: (uid) {
          DialogUtils.dismiss(context);

          Registry.folderValidated = 2;
          widget.parentState.goToPage(3);
        });
      }, 4000);
    } else {
      _anomalies.forEach((anomalie) {
        anomalie.filesAssociated.forEach((file) async {
          requestsPending++;

          RestClient.service
              .sendDocument(
            Const.API_TOKEN,
            Registry.uid,
            anomalie.idType,
            file,
          )
              .then((success) {
            _onRequestsFinished();
          }).catchError((Object object) {
            print(object);
            _onRequestsFinished();
          });
        });
      });
    }
  }

  void _onRequestsFinished() {
    requestsPending--;
    if (requestsPending == 0) {
      DialogUtils.dismiss(context);
      FirebaseUtils.setFolderState(Registry.uid, 'ANOMALIES_UPDATED',
          callback: (uid) {
        _anomalies = [];
        setState(() {});
      });
    }
  }

  Widget listOfAnomalies(List<Anomalie> anomalies, bool click) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: (65 * anomalies.length).toDouble(),
      margin: const EdgeInsets.only(top: 8.0),
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: anomalies.length,
        itemBuilder: (context, index) {
          Anomalie anomalie = anomalies[index];
          return GestureDetector(
            onTap: () {
              click == true ? showModal(anomalie) : print('not possible');
            },
            child: AnomalieRow(anomalie, click),
          );
        },
      ),
    );
  }
}
