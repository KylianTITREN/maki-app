import 'package:c_valide/basics/BaseStatelessWidget.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:flutter/material.dart';

class BottomSheetComponent extends BaseStatelessWidget {
  BottomSheetComponent({@required this.child, this.barColor, this.backgroundColor});

  Widget child;
  Color barColor;
  Color backgroundColor;

  @override
  Widget onBuild() {
    double paddingTop = 16.0;
    double paddingBottom = 16.0;
    double topBarHeight = 4.0;
    double totalTopBarHeight = (paddingTop + paddingBottom + topBarHeight);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: paddingTop,
              bottom: paddingBottom,
              left: 128.0,
              right: 128.0,
            ),
            child: Container(
              height: topBarHeight,
              decoration: BoxDecoration(
                color: barColor ?? Colours.lightGrey,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
        ),
        Container(
          color: backgroundColor ?? Colors.white,
          width: double.infinity,
          child: child ?? Container(),
          constraints: BoxConstraints(
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height - totalTopBarHeight - 25,
            // 25 = status bar height
          ),
        ),
      ],
    );
  }
}
