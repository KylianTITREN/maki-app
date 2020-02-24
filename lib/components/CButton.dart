import 'package:c_valide/res/Styles.dart';
import 'package:flutter/material.dart';

class CButton extends StatelessWidget {
  CButton(this._text, {this.textColor, this.color, this.enabled: true, this.onPressed});

  final String _text;
  final Color textColor;
  final Color color;
  final bool enabled;
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
      onPressed: enabled ? onPressed : null,
      color: color ?? Colors.blue,
      textColor: textColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}
