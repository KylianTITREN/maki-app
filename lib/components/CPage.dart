import 'package:flutter/material.dart';

class CPage extends StatelessWidget {
  CPage({this.child, this.backgroundColor});

  final Widget child;
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
    );
  }
}
