import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/basics/BaseState.dart';
import 'package:c_valide/basics/BaseStatefulWidget.dart';
import 'package:c_valide/components/CButton.dart';
import 'package:c_valide/components/CPage.dart';
import 'package:c_valide/components/CStepProgressBar.dart';
import 'package:c_valide/components/ThreePartsPage.dart';
import 'package:c_valide/pages/Step1Page.dart';
import 'package:c_valide/pages/Step2Page.dart';
import 'package:c_valide/pages/Step3Page.dart';
import 'package:c_valide/pages/Step4Page.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/res/HeroTags.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/res/Styles.dart';
import 'package:c_valide/utils/FirebaseUtils.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:flutter/material.dart';

class StepsPage extends BaseStatefulWidget {
  @override
  State onBuild() => StepsPageState();
}

class StepsPageState extends BaseState<StepsPage> {
  int _currentStep = 0;
  List<Widget> _pageViews;
  PageController _pageController;

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
  Widget onBuild() {
    return CPage(
      child: ThreePartsPage(
        middleExpanded: true,
        top: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 24.0),
            child: CStepProgressBar(
              <CStep>[
                CStep(
                  "Saisie",
                  Image.asset(
                    "images/writer.png",
                    height: 22,
                    width: 22,
                  ),
                ),
                CStep(
                  "Prise en charge",
                  Image.asset(
                    "images/flashlight.png",
                    height: 22,
                    width: 22,
                  ),
                  duration: 15000,
                  onLoadingFinished: () {
                    if (_currentStep == 1) {
                      FirebaseUtils.deleteFolder(Registry.uid, callback: () {
                        Registry.reset();
                      });

                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return Material(
                            color: Colours.overlay,
                            child: Container(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    Strings.textNoFreeAdvisor,
                                    style: Styles.text(context),
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 32.0),
                                    child: Text(
                                      Strings.textCallAgency,
                                      style: Styles.text(context),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 32.0),
                                    child: CButton(
                                      Strings.textNewEntry,
                                      color: Colours.primaryColor,
                                      onPressed: () {
                                        Page.quitPage(context);
                                        goToFirstPage();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                CStep(
                  "Validation",
                  Image.asset(
                    "images/checker.png",
                    height: 22,
                    width: 22,
                  ),
                ),
                CStep(
                  "Décision",
                  Image.asset(
                    "images/star.png",
                    height: 22,
                    width: 22,
                  ),
                ),
              ],
              currentStep: _currentStep,
              padding: EdgeInsets.all(16.0),
            ),
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
            margin: const EdgeInsets.only(bottom: 32.0),
            child: Hero(
              tag: HeroTags.cacfLogo,
              child: Material(
                color: Colors.transparent,
                child: Image.asset(
                  "images/cacf.png",
                  height: 30.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int get currentStep => _currentStep;

  void goToFirstPage() {
    _currentStep = 0;
    _animateToPage();
  }

  void goToNextPage() {
    _currentStep = (_currentStep + 1) % _pageViews.length;
    _animateToPage();
  }

  void _animateToPage() {
    _pageController.animateToPage(
      _currentStep,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );

    setState(() {});
  }
}
