import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
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

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
                opacity: animation,
                child: child,
              ),
        );
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    @required this.builder,
    RouteSettings settings,
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
  }
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
                scale: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: child,
              ),
        );
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
    CupertinoPageRoute(builder: (context) => route),
//      PageRouteBuilder(
//        pageBuilder: (context, _, __) {
//          return route;
//        },
//        transitionDuration: Duration(milliseconds: duration),
//      ),
  );
}

/// Start a new page on top of the current one
Future<void> topPage(BuildContext context, Widget route, {duration = 300}) {
  return Navigator.push(context, TransparentRoute(builder: (BuildContext context) => route));
//      PageRouteBuilder(
//        pageBuilder: (context, _, __) {
//          return route;
//        },
//        transitionDuration: Duration(milliseconds: duration),
//      ),
}

/// Start a new page on top of the current one
Future<void> fadePage(BuildContext context, Widget route, {duration = 300}) {
  return Navigator.pushReplacement(context, FadeRoute(page :route));
//      PageRouteBuilder(
//        pageBuilder: (context, _, __) {
//          return route;
//        },
//        transitionDuration: Duration(milliseconds: duration),
//      ),
}

/// Replace the current page with a new one
Future<void> replacePage(BuildContext context, Widget route, {duration = 300}) {
  return Navigator.of(context).pushReplacement(
    CupertinoPageRoute(builder: (context) => route),
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
    gravity: gravity ?? ToastGravity.TOP,
    backgroundColor: Colors.white,
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
