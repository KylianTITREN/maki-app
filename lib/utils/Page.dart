import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Delay a callback
///
/// duration in ms
void delay(VoidCallback callback, int duration) {
  Timer(Duration(milliseconds: duration), () {
    callback();
  });
}

/// Quit the current dialog
void quitApp() {
  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}

/// Quit the current dialog
bool quitDialog(BuildContext context) {
  return Navigator.of(context, rootNavigator: true).pop('dialog');
}

/// Quit the current page
bool quitPage(BuildContext context) {
  return Navigator.of(context).pop();
}

/// Start a new page on top of the current one
Future<void> startPage(BuildContext context, Widget route, {duration = 300}) {
  return Navigator.of(context).push(
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
Future<void> replacePage(BuildContext context, Widget route, {duration = 300}) {
  return Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => route),
//      PageRouteBuilder(
//        pageBuilder: (context, _, __) {
//          return route;
//        },
//        transitionDuration: Duration(milliseconds: duration),
//      ),
  );
}

void toast(
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

void dismissKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(new FocusNode());
}

void reloadBuildContext(BuildContext context){
  Theme.of(context);
}

class Page {
  static const MethodChannel _rotationChannel = const MethodChannel('forceOrientation');

  static void toLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
