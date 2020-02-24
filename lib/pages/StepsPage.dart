import 'dart:async';

import 'package:c_valide/api/Requests.dart';
import 'package:c_valide/api/RestClient.dart';
import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/basics/BaseState.dart';
import 'package:c_valide/basics/BaseStatefulWidget.dart';
import 'package:c_valide/components/CPage.dart';
import 'package:c_valide/components/CStepProgressBar.dart';
import 'package:c_valide/components/SatisfactionPopup.dart';
import 'package:c_valide/components/ShopPopup.dart';
import 'package:c_valide/components/ThreePartsPage.dart';
import 'package:c_valide/models/Anomalies.dart';
import 'package:c_valide/models/Magasin.dart';
import 'package:c_valide/pages/Step1Page.dart';
import 'package:c_valide/pages/Step2Page.dart';
import 'package:c_valide/pages/Step3Page.dart';
import 'package:c_valide/pages/Step4Page.dart';
import 'package:c_valide/res/HeroTags.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/utils/Dialogs.dart';
import 'package:c_valide/utils/FirebaseUtils.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notifier/notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  int showPopup = 0;
  Magasin filterMagasin;

  @override
  void initState() {
    super.initState();

    _pageViews = <Widget>[
      StepPage1(this),
      StepPage2(this),
      StepPage3(this),
      StepPage4(this),
    ];

    if (Registry.magasin == null && Registry.activeShop == true) {
      Timer(Duration(seconds: 3), () => showPopup == 0 ? _chooseShop() : null);
    }else{
      Registry.chatUid.isEmpty ? _createChat() : _updateChatShopId();
    }

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
      Registry.oldState = 'MOBILE_APP_CLOSED';
      FirebaseUtils.setFolderState(Registry.uid, 'MOBILE_APP_CLOSED');
    }
  }

  @override
  void onInactive() {
    if (currentStep > 0) {
      Registry.oldState = 'MOBILE_APP_CLOSED';
      FirebaseUtils.setFolderState(Registry.uid, 'MOBILE_APP_CLOSED');
    }
  }

  @override
  void onPause() {
    if (currentStep > 0) {
      Registry.oldState = 'MOBILE_APP_CLOSED';
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
            {
              Registry.dialog = false;
              goToPage(2);
              break;
            }
          case 'IN_PROGRESS':
            {
              goToPage(2);
              break;
            }
          case 'ANOMALIES':
            {
              _startAnomaliesRequests();
              Registry.dialog = true;
              break;
            }
          case 'REFUSED':
            {
              Registry.folderValidated = 0;
              Registry.dialog = true;
              _startAnomaliesRequests();
              goToPage(3);
              break;
            }
          case 'CANCELED':
            {
              // cancelSubscription();
              Registry.folderValidated = 1;
              Registry.dialog = true;
              _startAnomaliesRequests();
              goToPage(3);
              break;
            }
          case 'VALIDATED':
            {
              // cancelSubscription();
              Registry.comment = '';
              Registry.dialog = false;
              Registry.folderValidated = 2;
              goToPage(3);
              break;
            }
        }
      },
    );
  }

  void cancelSubscription() {
    dismissKeyboard(context);
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
        _startFolderAdvisorTextRequest();
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

  void updateData(Magasin shopChoosen) {
    LoadingDialog(context, text: Strings.textLoading).show();
    Requests.getShop(context, onSuccess: () {
      quitDialog(context);
      setState(() {
        Registry.magasin = shopChoosen;
      });
    }, onFailed: () {
      quitDialog(context);
    });
  }

  void _createChat() {
    FirebaseUtils.createChat(
      Registry.uid == null ? '' : Registry.uid,
      Registry.folderNumber == null ? '' : Registry.folderNumber,
      Registry.magasin == null ? 0 : int.parse(Registry.magasin.id),
      Registry.magasin == null ? "" : Registry.magasin.name,
      callback: (String uid) {
        _listenUnreadChat();
        Registry.chatUid = uid;
      },
    );
  }

  void _updateChatShopId() {
    FirebaseUtils.updateShopId(
      Registry.chatUid,
      int.parse(Registry.magasin.id),
      Registry.magasin.name,
    );
  }

  void _chooseShop() {
    showPopup++;
    if (Registry.uid.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => ShopPopup(
          onValueChanged: (filterMagasin) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('magasinName', filterMagasin.name);
            prefs.setInt('magasinId', int.parse(filterMagasin.id));
            Registry.magasin = filterMagasin;
            quitDialog(context);
            updateData(filterMagasin);
            Registry.chatUid.isEmpty ? _createChat() : _updateChatShopId();
          },
        ),
      );
    }
  }

  void _listenUnreadChat() {
    FirebaseUtils.listenUnreadChat(Registry.chatUid, callback: (value) {
      setState(() {
        Registry.messageBadge = value;
      });
    });
  }

  @override
  Widget onBuild() {
    print(Registry.mobileDelay);
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
                    _currentStep = 0;
                    quitDialog(context);
                    FirebaseUtils.deleteMessages();
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
        appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: () {
                  _chooseShop();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      Registry.magasin == null
                          ? 'Aucun sélectionné'
                          : Registry.magasin.name,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Image.asset(
                      "assets/images/shape-shop.png",
                      fit: BoxFit.contain,
                      color: Colors.white,
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        child: ThreePartsPage(
          middleExpanded: true,
          top: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 0),
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
                          duration: Registry.mobileDelay, // 5 minutes
                          onLoadingFinished: () {
                            if (_currentStep == 1) {
                              FirebaseUtils.deleteMessages();
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
    FirebaseUtils.deleteMessages();

    goToFirstPage();
  }

  void goToFirstPage() {
    _currentStep = 0;
    dismissKeyboard(context);
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
    dismissKeyboard(context);
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
