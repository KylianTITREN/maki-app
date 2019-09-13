import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Page {
  static const MethodChannel _rotationChannel = const MethodChannel('forceOrientation');

  static void toLandscape() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    if (Platform.isIOS) {
      _rotationChannel?.invokeMethod('setLandscape');
    }
  }

  static void toPortrait() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (Platform.isIOS) {
      _rotationChannel?.invokeMethod('setPortrait');
    }
  }

  /// Quit the current dialog
  static void quitDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true)?.pop('dialog');
  }

  /// Quit the current page
  static void quitPage(BuildContext context) {
    Navigator.of(context)?.pop();
  }

  /// Start a new page on top of the current one
  static void startPage(BuildContext context, Widget route, {duration = 300}) {
    Navigator.of(context)?.push(
      MaterialPageRoute(builder: (context) => route),
    );
  }

  /// Replace the current page with a new one
  static void replacePage(BuildContext context, Widget route, {duration = 300}) {
    Navigator.of(context)?.pushReplacement(
      MaterialPageRoute(builder: (context) => route),
    );
  }

  /// Delay a callback
  ///
  /// duration in ms
  static void delay(VoidCallback callback, int duration) {
    Timer(Duration(milliseconds: duration), () {
      callback();
    });
  }

  static void toast(
    String msg, {
    Toast toastLength,
    int timeInSecForIos,
    double fontSize,
    ToastGravity gravity,
    Color backgroundColor,
    Color textColor,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      timeInSecForIos: timeInSecForIos ?? 1,
      fontSize: fontSize ?? 16.0,
      gravity: gravity ?? ToastGravity.BOTTOM,
      backgroundColor: backgroundColor ?? Colors.grey,
      textColor: textColor ?? Color.fromARGB(255, 40, 40, 40),
    );
  }

  ///
  static void requestFocus(
    BuildContext context,
    FocusNode currentFocusNode,
    FocusNode nextFocusNode,
  ) {
    currentFocusNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
