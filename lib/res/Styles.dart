import 'package:c_valide/app/Misc.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:flutter/material.dart';

class Styles {
  static TextStyle splashcreenTitle(BuildContext context) {
    return TextStyle(
      color: Colours.primaryColor,
      fontSize: 42.0,
      fontWeight: FontWeight.w900,
      fontFamily: 'GothamRounded',
    );
  }

  static TextStyle appBarTitle(BuildContext context) {
    return TextStyle(
      color: Colours.primaryColor,
      fontSize: 22.0,
      fontFamily: 'GothamRounded',
    );
  }

  static TextStyle popupTitle(BuildContext context) {
    return TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle title(BuildContext context) {
    return TextStyle(
      color: Colours.primaryColor,
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle subtitle(BuildContext context) {
    return TextStyle(
      color: Colours.primaryColor,
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle subsubtitle(BuildContext context) {
    return TextStyle(
      color: Colours.primaryColor,
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle text(BuildContext context) {
    return TextStyle(
      color: Colors.white,
      fontSize: Misc.isTablet(context) ? 20.0 : 16.0,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle textThin(BuildContext context) {
    return TextStyle(
      color: Colors.white,
      fontSize: Misc.isTablet(context) ? 19.0 : 15.0,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle description(BuildContext context) {
    return TextStyle(
      color: Colors.white,
      fontSize: Misc.isTablet(context) ? 21.0 : 16.0,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle littleTextPrimary(BuildContext context) {
    return TextStyle(
      color: Colours.primaryColor,
      fontSize: Misc.isTablet(context) ? 18.0 : 14.0,
      fontWeight: FontWeight.w500,
    );
  }

  static InputDecoration editText(BuildContext context, {String hint}) {
    return InputDecoration(
      counterText: '',
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(
          color: Colors.black54,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(
          color: Colors.black54,
        ),
      ),
      contentPadding: EdgeInsets.only(left: 8.0, right: 8.0, top: 32.0),
      filled: true,
      fillColor: Colours.field,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0),
        ),
      ),
    );
  }

  static InputDecoration textField(BuildContext context, {String hint, Color hintColor}) {
    return InputDecoration(
      labelText: hint ?? '',
      hintStyle: TextStyle(fontSize: 14.0, color: hintColor ?? Colors.black),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
    );
  }

  static InputDecoration textFieldDisabled(BuildContext context, String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colours.lightGrey,
      labelText: hint,
      labelStyle: TextStyle(
        color: Color.fromARGB(255, 75, 75, 75),
        fontSize: 18.0,
        fontWeight: FontWeight.w900,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.0),
        borderSide: BorderSide(
          width: 0.0,
          style: BorderStyle.none,
        ),
      ),
    );
  }

  static button(BuildContext context) {}
}
