import 'package:c_valide/basics/BaseState.dart';
import 'package:c_valide/components/CProgressBar.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:flutter/material.dart';

class CStepProgressBar extends StatefulWidget {
  CStepProgressBar(this.steps, {this.currentStep: 0, this.padding: const EdgeInsets.all(0.0)})
      : assert(steps != null && currentStep >= 0);

  final List<CStep> steps;
  final int currentStep;
  final EdgeInsets padding;

  @override
  State<StatefulWidget> createState() =>
      _CStepProgressBarState(this.steps, this.currentStep, this.padding);
}

class _CStepProgressBarState extends BaseState<CStepProgressBar>
    with SingleTickerProviderStateMixin {
  _CStepProgressBarState(this._steps, this._currentStep, this._padding);

  List<CStep> _steps;
  int _currentStep;
  EdgeInsets _padding;

  @override
  void didUpdateWidget(CStepProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentStep != widget.currentStep) {
      _currentStep = widget.currentStep;
    }

    if (oldWidget.steps != widget.steps) {
      _steps = widget.steps;
    }

    if (oldWidget.padding != widget.padding) {
      _padding = widget.padding;
    }

    setState(() {});
  }

  @override
  Widget onBuild() {
    double maxWidth = mq.size.width - _padding.horizontal;
    int stepsNumber = _steps.length;

    const double tilt = 10.0;
    const double height1 = 70.0;
    const double height2 = 60.0;

    return Padding(
      padding: _padding,
      child: Row(
        children: List.generate(
          stepsNumber,
          (index) {
            CStep step = _steps[index];

            return Wrap(
              children: <Widget>[
                CProgressBar(
                  index: index,
                  currentStep: _currentStep,
                  isFirst: index == 0,
                  isLast: index == stepsNumber - 1,
                  duration: step.duration,
                  radius: 20.0,
                  tilt: _currentStep == index ? tilt * height1 / height2 : tilt,
                  icon: step.icon,
                  text: step.text,
                  maxSize: Size(maxWidth / stepsNumber, _currentStep == index ? height1 : height2),
                  color: index == _currentStep && step.duration >= 0
                      ? Colours.grey
                      : Colours.primaryColor,
                  onLoadingFinished: step.onLoadingFinished,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CStep {
  CStep(this._text, this._icon, {this.duration: 0, this.onLoadingFinished});

  String _text;
  Widget _icon;
  int duration;
  VoidCallback onLoadingFinished;

  String get text => _text;

  Widget get icon => _icon;
}
