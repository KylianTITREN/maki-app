import 'package:c_valide/basics/BaseStatelessWidget.dart';
import 'package:flutter/material.dart';

class SafeScrollView extends BaseStatelessWidget {
  SafeScrollView({@required this.child});

  final Widget child;

  @override
  Widget onBuild() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          height: mq.size.height - mq.padding.top,
          child: child ?? Container(),
        ),
      ),
    );
  }
}
