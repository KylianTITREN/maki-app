import 'package:c_valide/components/BottomMsg.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:flutter/material.dart';

class CPage extends StatelessWidget {
  CPage({this.child, this.fab, this.backgroundColor});

  final Widget child;
  final Widget fab;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor ?? Colors.black87,
        child: SafeArea(
          child: child,
        ),
      ),
      floatingActionButton: fab,
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
