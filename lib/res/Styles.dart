import 'package:flutter/material.dart';

const PrimaryColor = const Color(0xFF494949);
const PrimaryColorLight = const Color(0xFF494949);
const PrimaryColorDark = const Color(0xFFFFFFFF);

const SecondaryColor = const Color(0xFFFFA942);
const SecondaryColorLight = const Color(0xFFFFA942);
const SecondaryColorDark = const Color(0xFFFFA942);

const CardColor = const Color(0xFFFFFFFF);
const DarkCardColor = const Color(0xFF222727);

const Background = const Color(0xFFFFFFFF);
const TextColor = const Color(0xFF494949);

const DarkTextColor = const Color(0xFFFFFFFF);

const DarkBackground = const Color(0xFF000000);

class Styles {
  static final ThemeData defaultTheme = _buildTheme();

  static ThemeData _buildTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      appBarTheme: base.appBarTheme.copyWith(
        color: Background,
        elevation: 0,
      ),
      accentColor: SecondaryColor,
      accentColorBrightness: Brightness.dark,
      primaryColor: PrimaryColor,
      primaryColorDark: PrimaryColorDark,
      primaryColorLight: PrimaryColorLight,
      primaryColorBrightness: Brightness.dark,
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: SecondaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      scaffoldBackgroundColor: Background,
      cardColor: CardColor,
      textSelectionColor: PrimaryColorLight,
      backgroundColor: Background,
      textTheme: base.textTheme
          .copyWith(
              title: base.textTheme.title.copyWith(color: TextColor),
              body1: base.textTheme.body1.copyWith(color: TextColor),
              body2: base.textTheme.body2.copyWith(color: TextColor))
          .apply(fontFamily: 'Lato', bodyColor: TextColor),
    );
  }

  static final ThemeData darkTheme = _buildDarkTheme();

  static ThemeData _buildDarkTheme() {
    final ThemeData base = ThemeData.dark();

    return base.copyWith(
      appBarTheme: base.appBarTheme.copyWith(
        color: DarkBackground,
        elevation: 0,
      ),
      accentColor: SecondaryColorDark,
      accentColorBrightness: Brightness.dark,
      primaryColor: PrimaryColorDark,
      primaryColorDark: PrimaryColorDark,
      primaryColorLight: PrimaryColorLight,
      primaryColorBrightness: Brightness.dark,
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: SecondaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      scaffoldBackgroundColor: DarkBackground,
      cardColor: DarkCardColor,
      textSelectionColor: PrimaryColorLight,
      backgroundColor: DarkBackground,
      textTheme: base.textTheme.copyWith(
          title: base.textTheme.title.copyWith(color: DarkTextColor),
          body1: base.textTheme.body1.copyWith(color: DarkTextColor),
          body2: base.textTheme.body2.copyWith(color: DarkTextColor)),
    );
  }

  static InputDecoration formField(BuildContext context, {String placeholder, bool dropdown}) {
    return InputDecoration(
      counterText: '',
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      suffixIcon: dropdown != null && dropdown == true ? Icon(Icons.arrow_drop_down) : null,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      contentPadding: EdgeInsets.only(left: 20.0, right: 8.0, top: 32.0),
      filled: true,
      fillColor: Theme.of(context).backgroundColor,
      hintText: placeholder,
      hintStyle: TextStyle(fontSize: 14, color: dropdown != null && dropdown == true ? Theme.of(context).primaryColor : Colors.black26),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14.0)),
      ),
    );
  }
}
