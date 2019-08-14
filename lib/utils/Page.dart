import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Page {
  /// Quit the current page
  static void quitPage(BuildContext context) {
    Navigator.of(context).pop();
//    Navigator.pop(context);
  }

  /// Start a new page on top of the current one
  static void startPage(BuildContext context, Widget route, {duration = 300}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => route),
//      PageRouteBuilder(
//        pageBuilder: (context, _, __) {
//          return route;
//        },
//        transitionDuration: Duration(milliseconds: duration),
//      ),
    );
  }

  /// Replace the current page with a new one
  static void replacePage(BuildContext context, Widget route, {duration = 300}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => route),
//      PageRouteBuilder(
//        pageBuilder: (context, _, __) {
//          return route;
//        },
//        transitionDuration: Duration(milliseconds: duration),
//      ),
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
      BuildContext context, FocusNode currentFocusNode, FocusNode nextFocusNode) {
    currentFocusNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
}
