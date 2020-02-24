import 'package:c_valide/FlavorConfig.dart';
import 'package:c_valide/components/BottomMsg.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:flutter/material.dart';
import 'package:c_valide/app/Registry.dart';

class CPage extends StatelessWidget {
  CPage({this.child, this.appBar, this.fab, this.backgroundColor});

  final Widget child;
  final Widget appBar;
  final Widget fab;
  final Color backgroundColor;

  static String parentFolder = FlavorConfig.isProduction() ? 'prod' : 'test';
  int unread = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        color: backgroundColor ?? Colors.black87,
        child: SafeArea(
          child: child,
        ),
      ),
      floatingActionButton: Registry.activeMessage != false
          ? Stack(
              children: <Widget>[
                fab,
                Container(
                  transform: Matrix4.translationValues(-7.0, -7.0, 0.0),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Registry.messageBadge != 0
                          ? Colors.red
                          : Colors.transparent),
                  child: Text(
                    Registry.messageBadge != 0
                        ? Registry.messageBadge.toString()
                        : '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}

class MyFloatingButton extends StatefulWidget {
  @override
  _MyFloatingButtonState createState() => _MyFloatingButtonState();
}

class _MyFloatingButtonState extends State<MyFloatingButton> {
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    return _show
        ? FloatingActionButton(
            backgroundColor: Colours.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Image.asset("assets/images/msg-shape.png"),
            ),
            onPressed: () {
              var sheetController = showBottomSheet(
                  context: context,
                  backgroundColor: Colors.black54,
                  builder: (context) => BottomMsg());

              _showButton(false);

              sheetController.closed.then((value) {
                _showButton(true);
              });
            },
          )
        : Container();
  }

  void _showButton(bool value) {
    setState(() {
      _show = value;
    });
  }
}
