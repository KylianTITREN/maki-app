import 'package:c_valide/components/CPage.dart';
import 'package:flutter/material.dart';

class ScrollablePage extends StatelessWidget {
  ScrollablePage({this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CPage(
      child: ListView(
        children: children,
      ),
    );
  }
}
