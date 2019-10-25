import 'package:c_valide/components/PisaTower.dart';
import 'package:flutter/material.dart';

class CProgressBar extends StatefulWidget {
  CProgressBar({
    this.index,
    this.currentStep: 0,
    this.radius: 10,
    this.tilt: 0,
    this.icon,
    this.text,
    this.maxSize: const Size(125, 75),
    this.color,
    this.backgroundColor,
    this.duration: 0,
    this.isFirst: false,
    this.isLast: false,
    this.onLoadingFinished,
  });

  final int index;
  final int currentStep;
  final double radius;
  final double tilt;
  final Widget icon;
  final String text;
  final Size maxSize;
  final Color color;
  final Color backgroundColor;
  final int duration;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onLoadingFinished;

  @override
  State<StatefulWidget> createState() => _CProgressBarState(
        this.index,
        this.currentStep,
        this.radius,
        this.tilt,
        this.icon,
        this.text,
        this.maxSize,
        this.color,
        this.backgroundColor,
        this.isFirst,
        this.isLast,
        this.duration,
      );
}

class _CProgressBarState extends State<CProgressBar> with SingleTickerProviderStateMixin {
  _CProgressBarState(
    this._index,
    this._currentStep,
    this._radius,
    this._tilt,
    this._icon,
    this._text,
    this._maxSize,
    this._color,
    this._backgroundColor,
    this._isFirst,
    this._isLast,
    this._duration,
  );

  int _index;
  int _currentStep;
  double _radius;
  double _tilt;
  Widget _icon;
  String _text;
  Size _maxSize;
  Color _color;
  Color _backgroundColor;
  bool _isFirst;
  bool _isLast;
  int _duration;

  AnimationController controller;
  Animation<double> animation;

  bool get isCompleted => _index < _currentStep;

  bool get isCurrentStep => _index == _currentStep;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds: _duration), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });

        if (animation.value >= 1.0) {
          widget.onLoadingFinished();
        }
      });
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  void didUpdateWidget(CProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.index != widget.index) {
      _index = widget.index;
    }

    if (oldWidget.currentStep != widget.currentStep) {
      _currentStep = widget.currentStep;
      controller.reset();
    }

    if (oldWidget.radius != widget.radius) {
      _radius = widget.radius;
    }

    if (oldWidget.tilt != widget.tilt) {
      _tilt = widget.tilt;
    }

    if (oldWidget.icon != widget.icon) {
      _icon = widget.icon;
    }

    if (oldWidget.text != widget.text) {
      _text = widget.text;
    }

    if (oldWidget.maxSize != widget.maxSize) {
      _maxSize = widget.maxSize;
    }

    if (oldWidget.color != widget.color) {
      _color = widget.color;
    }

    if (oldWidget.backgroundColor != widget.backgroundColor) {
      _backgroundColor = widget.backgroundColor;
    }

    if (oldWidget.isFirst != widget.isFirst) {
      _isFirst = widget.isFirst;
    }

    if (oldWidget.isLast != widget.isLast) {
      _isLast = widget.isLast;
    }

    if (oldWidget.duration != widget.duration) {
      _duration = widget.duration;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isCurrentStep && _duration > 0 && !isCompleted) {
      controller.forward();
    }

    double actualWidth = _maxSize.width - (_isFirst || _isLast ? 0 : _tilt);

    return Stack(
      children: <Widget>[
        PisaTower(
          tilt: _tilt,
          maxSize: _maxSize,
          radius: _radius,
          foregroundWidth: isCompleted
              ? actualWidth
              : (!isCurrentStep
                  ? 0
                  : (_duration <= 0 ? actualWidth : (animation.value * actualWidth))),
          color: _color ?? Theme.of(context).primaryColor,
          backgroundColor: _backgroundColor ?? Color.fromARGB(255, 50, 50, 50),
          hasRoundedBorderLeft: _isFirst,
          hasRoundedBorderRight: _isLast,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: _tilt),
          width: _maxSize.width,
          height: _maxSize.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _icon ?? Container(),
              SizedBox(height: 5),
              Text(
                _text,
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
