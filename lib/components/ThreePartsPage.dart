import 'package:flutter/material.dart';

class ThreePartsPage extends StatelessWidget {
  ThreePartsPage({this.top, this.middle, this.bottom, this.minimize: false, this.middleExpanded: false});

  final Widget top;
  final Widget middle;
  final Widget bottom;
  final bool minimize;
  final bool middleExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: minimize ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        top ?? Container,
        middle != null ? middleExpanded ? Expanded(child: middle) : middle : Container(),
        bottom ?? Container,
      ],
    );
  }
}
