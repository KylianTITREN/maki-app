import 'package:c_valide/res/Styles.dart';
import 'package:flutter/material.dart';

class CButton extends StatelessWidget {
  CButton(this._text, {this.color, this.onPressed});

  final String _text;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: const EdgeInsets.only(
        top: 12.0,
        bottom: 12.0,
        left: 32.0,
        right: 32.0,
      ),
      child: Text(
        _text,
        style: Styles.text(context),
      ),
      onPressed: onPressed,
      color: color,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}
