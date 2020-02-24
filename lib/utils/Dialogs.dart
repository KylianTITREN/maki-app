import 'dart:io';

import 'package:maki_app/res/colours.dart';
import 'package:maki_app/utils/Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class BasicDialog extends StatelessWidget {
  BasicDialog(this.context);

  final BuildContext context;

  void show() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: this,
        );
      },
    );
  }

  void dismiss() {
    Navigator.of(context).pop();
  }
}

class InformationDialog extends BasicDialog {
  InformationDialog(context, {@required this.text, this.textButton = 'OK'}) : super(context);

  final String text;
  final String textButton;

  @override
  Widget build(BuildContext context) {
    return ChoicesDialog(
      context,
      Text(text),
      actions: <String, VoidCallback>{
        textButton: () {
          quitDialog(context);
        }
      },
    );
  }
}

class ChoiceDialog extends BasicDialog {
  ChoiceDialog(
    context,
    this.text, {
    this.positive,
    this.negative,
    this.onPositive,
    this.onNegative,
  })  : assert(
          (positive == null && onPositive == null) || (positive != null && onPositive != null),
          (negative == null && onNegative == null) || (negative != null && onNegative != null),
        ),
        super(context);

  final String text;
  final Widget positive;
  final Widget negative;
  final VoidCallback onPositive;
  final VoidCallback onNegative;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            onPressed: onPositive,
            child: positive ?? Container(),
          ),
          FlatButton(
            onPressed: onNegative,
            child: negative ?? Container(),
          ),
        ],
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(text ?? ''),
        ),
      );
    } else {
      return CupertinoAlertDialog(
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(text ?? ''),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: onPositive,
              child: positive ?? Container(),
            ),
            CupertinoDialogAction(
              onPressed: onNegative,
              child: negative ?? Container(),
            ),
          ]);
    }
  }
}

class ChoicesDialog extends BasicDialog {
  ChoicesDialog(
    context,
    this.content, {
    this.actions,
  }) : super(context);

  final Widget content;
  final Map<String, VoidCallback> actions;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AlertDialog(
        content: Container(
//          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: content ?? Container(),
        ),
        actions: actions.keys
            .where((e) => e != null)
            .map(
              (e) => FlatButton(
                onPressed: actions[e],
                child: Text(e),
              ),
            )
            .toList(),
      );
    } else {
      return CupertinoAlertDialog(
        content: Container(
//          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: content ?? Container(),
        ),
        actions: actions.keys
            .where((e) => e != null)
            .map(
              (e) => CupertinoDialogAction(
                child: Text(e),
                textStyle: TextStyle(color: e == 'Supprimer' ? Colors.red : Colours.primaryColor),
                onPressed: actions[e],
              ),
            )
            .toList(),
      );
    }
  }
}

class LoadingDialog extends BasicDialog {
  LoadingDialog(context, {this.text}) : super(context);

  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(text ?? ''),
          ),
        ],
      ),
    );
  }
}
