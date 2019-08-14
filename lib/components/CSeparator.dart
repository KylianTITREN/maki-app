import 'package:flutter/material.dart';

class CSeparator extends StatelessWidget {
  CSeparator(this._color, {this.width : 100, this.height : 2});

  final Color _color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: _color,
      margin: EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
    );
  }
}
