import 'dart:async';

import 'package:c_valide/api/RestClient.dart';
import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/basics/BaseState.dart';
import 'package:c_valide/basics/BaseStatefulWidget.dart';
import 'package:c_valide/components/CPage.dart';
import 'package:c_valide/components/CStepProgressBar.dart';
import 'package:c_valide/components/SatisfactionPopup.dart';
import 'package:c_valide/components/ThreePartsPage.dart';
import 'package:c_valide/models/Anomalies.dart';
import 'package:c_valide/pages/Step1Page.dart';
import 'package:c_valide/pages/Step2Page.dart';
import 'package:c_valide/pages/Step3Page.dart';
import 'package:c_valide/pages/Step4Page.dart';
import 'package:c_valide/res/HeroTags.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/utils/FirebaseUtils.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notifier/notifier.dart';

class StepsPage extends BaseStatefulWidget {
  @override
  State onBuild() => StepsPageState();
}

class StepsPageState extends BaseState<StepsPage> {
  int _requestsPending = 0;
  int _currentStep = 0;
  bool showMsg = false;
  String _currentState = '';
  List<Widget> _pageViews;
  PageController _pageController;
  StreamSubscription<Event> _subscription;

  @override
  void initState() {
    super.initState();

    _pageViews = <Widget>[
      StepPage1(this),
      StepPage2(this),
      StepPage3(this),
      StepPage4(this),
    ];

    _pageController = PageController(
      initialPage: _currentStep,
    );
  }

  @override
  void onResume() {
    if (currentStep > 0) {
      FirebaseUtils.setFolderState(Registry.uid, currentState);
    }
  }

  @override
  void onSuspend() {
    if (currentStep > 0) {
      FirebaseUtils.setFolderState(Registry.uid, 'MOBILE_APP_CLOSED');
    }
  }

  @override
  void onInactive() {
    if (currentStep > 0) {
      FirebaseUtils.setFolderState(Registry.uid, 'MOBILE_APP_CLOSED');
    }
  }

  @override
  void onPause() {
    if (currentStep > 0) {
      FirebaseUtils.setFolderState(Registry.uid, 'MOBILE_APP_CLOSED');
    }
  }

  void initSubscription() {
    _subscription = FirebaseUtils.listenState(
      Registry.uid,
      [
        'CREATED',
        'IN_PROGRESS',
        'ANOMALIES',
        'ANOMALIES_UPDATED',
        'REFUSED',
        'VALIDATED',
        'CANCELED'
      ],
      callback: (state) {
        _currentState = state;
        switch (state) {
          case 'CREATED':
            {
              goToPage(1);
              break;
            }
          case 'ANOMALIES_UPDATED':
          case 'IN_PROGRESS':
            {
              goToPage(2);
              break;
            }
          case 'ANOMALIES':
            {
              _startAnomaliesRequests();
              break;
            }
          case 'REFUSED':
            {
              Registry.folderValidated = 0;
              _startAnomaliesRequests();
              goToPage(3);
              break;
            }
          case 'CANCELED':
            {
              cancelSubscription();
              Registry.folderValidated = 1;
              _startAnomaliesRequests();
              goToPage(3);
              break;
            }
          case 'VALIDATED':
            {
              cancelSubscription();
              Registry.folderValidated = 2;
              goToPage(3);
              break;
            }
        }
      },
    );
  }

  void cancelSubscription() {
    _subscription?.cancel();
  }

  void _startAnomaliesRequests() {
    _startFolderCommentRequest();
    _startAnomaliesRequest();
  }

  void _startFolderCommentRequest() {
    _requestsPending++;
    FirebaseUtils.getFolderComment(
      Registry.uid,
      callback: (comment) {
        Registry.comment = comment;
        if (comment.isNotEmpty) {
          _startFolderAdvisorTextRequest();
        }
        Notifier.of(context).notify(Strings.notifyComment, Registry.comment);
        _onRequestFinished();
        return;
      },
    );
  }

  void _startFolderAdvisorTextRequest() {
    FirebaseUtils.getAdvisorText(Registry.uid, callback: (advisorText) {
      Registry.advisorText = advisorText;
      return;
    });
  }

  void _startAnomaliesRequest() {
    _requestsPending++;
    RestClient.service.getAnomalies(Registry.uid).then((Anomalies anomalies) {
      Registry.comment = anomalies.comment;
      Notifier.of(context).notify(Strings.notifyComment, Registry.comment);
      Notifier.of(context)
          .notify(Strings.notifyAnomalies, anomalies.anomalieTypes);
      _onRequestFinished();
    }).catchError((Object object) {
      print(object);
    });
  }

  void _onRequestFinished() {
    if (--_requestsPending == 0) {
      Registry.folderValidated == 0 || Registry.folderValidated == 1
          ? cancelSubscription()
          : goToPage(2);
    }
  }

  @override
  Widget onBuild() {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    quitDialog(context);
                  },
                  child: Text(Strings.textNo),
                ),
                FlatButton(
                  onPressed: () {
                    quitDialog(context);
                    FirebaseUtils.deleteFolder(Registry.uid,
                        callback: restartStepsPage);
                  },
                  child: Text(Strings.textYes),
                ),
              ],
              content: Text(Strings.textAreYouSureToLeave),
            );
          },
        );

        return false;
      },
      child: CPage(
        child: ThreePartsPage(
          middleExpanded: true,
          top: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 40.0, bottom: 0),
              child: _currentStep > 0
                  ? CStepProgressBar(
                      <CStep>[
                        CStep(
                          "Saisie",
                          Image.asset(
                            "assets/images/writer.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                        CStep(
                          "Prise en charge",
                          Image.asset(
                            "assets/images/flashlight.png",
                            height: 20,
                            width: 20,
                          ),
                          duration: 60000 * 5, // 5 minutes
                          onLoadingFinished: () {
                            if (_currentStep == 1) {
                              FirebaseUtils.deleteFolder(Registry.uid,
                                  callback: () {
                                Registry.reset();
                              });

                              NotifierProvider.of(context).notify(
                                Strings.notifyNoAdvisor,
                                true,
                              );
                            }
                          },
                        ),
                        CStep(
                          "Validation",
                          Image.asset(
                            "assets/images/checker.png",
                            height: 20,
                            width: 20,
                          ),
                        ),
                        CStep(
                          "Décision",
                          Image.asset(
                            "assets/images/star.png",
                            height: 20,
                            width: 20,
                          ),
                          duration: -1,
                        ),
                      ],
                      currentStep: _currentStep,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    )
                  : Container(),
            ),
          ),
          middle: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: _pageViews,
          ),
          bottom: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 25.0),
              child: Hero(
                tag: HeroTags.cacfLogo,
                child: Material(
                  color: Colors.transparent,
                  child: Image.asset(
                    "assets/images/cacf.png",
                    height: 27.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        fab: MyFloatingButton(),
      ),
    );
  }

  int get currentStep => _currentStep;

  String get currentState => _currentState;

  void restartStepsPage() {
    cancelSubscription();

    Registry.reset();

    goToFirstPage();
  }

  void goToFirstPage() {
    _currentStep = 0;
    _animateToPage();
  }

  void goToNextPage() {
    _currentStep = (_currentStep + 1) % _pageViews.length;
    _animateToPage();
  }

  void goToPage(int page) {
    _currentStep = page % _pageViews.length;
    _animateToPage();
  }

  void _animateToPage() {
    _pageController.animateToPage(
      _currentStep,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  void onStepsOver([VoidCallback callback]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SatisfactionPopup(callback);
      },
    );
  }
}
