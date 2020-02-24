import 'package:flutter/material.dart';
import 'package:maki_app/components/header.dart';

class BottomSheetComponent extends StatelessWidget {
  BottomSheetComponent(
      {@required this.child, this.title, this.icon});

  Widget child;
  String title;
  String icon;

  @override
  Widget build(BuildContext context) {
    double paddingTop = 20;
    double paddingBottom = 25.0;
    double topBarHeight = 5.0;
    double totalTopBarHeight = (paddingTop + paddingBottom + topBarHeight);

    return Stack(children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: paddingTop,
                bottom: paddingBottom,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 6,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 145),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Theme.of(context).backgroundColor,
            width: double.infinity,
            child: child ?? Container(),
            constraints: BoxConstraints(
              minHeight: 0,
              maxHeight: MediaQuery.of(context).size.height -
                  totalTopBarHeight -
                  MediaQuery.of(context).padding.bottom -
                  MediaQuery.of(context).size.height * 0.23,
              // 25 = status bar height
            ),
          ),
        ],
      ),
      Positioned(
        top: 0,
        child: Container(
          height: 105,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: RotatedBox(
              quarterTurns: 10,
              child: Image.asset('assets/images/wave.png', fit: BoxFit.cover),
            ),
          ),
        ),
      ),
      Positioned(
        top: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: paddingTop,
              bottom: paddingBottom,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 6,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 145),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top:14,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              CustomHeader(
                icon: icon ?? '🥺',
                isize: 85,
                title: title ?? 'Titre inconnu',
                func: null,
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
