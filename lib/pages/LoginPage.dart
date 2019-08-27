import 'package:c_valide/app/Const.dart';
import 'package:c_valide/basics/BaseState.dart';
import 'package:c_valide/basics/BaseStatefulWidget.dart';
import 'package:c_valide/components/CButton.dart';
import 'package:c_valide/components/CSeparator.dart';
import 'package:c_valide/components/SafeScrollView.dart';
import 'package:c_valide/pages/StepsPage.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/res/HeroTags.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/res/Styles.dart';
import 'package:c_valide/utils/Cache.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:flutter/material.dart';

class LoginPage extends BaseStatefulWidget {
  @override
  State onBuild() => LoginPageState();
}

class LoginPageState extends BaseState<LoginPage> {
  String _password;

  final _formKey = GlobalKey<FormState>();

  final FocusNode _passwordFocus = FocusNode();

  @override
  Widget onBuild() {
    if (Const.FAST_MODE_ENABLED || _isLogged()) {
      _password = Const.CORRECT_PASSWORD;
    }

    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: SafeScrollView(
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 32.0),
                      child: Hero(
                        tag: HeroTags.logo,
                        child: Material(
                          color: Colors.transparent,
                          child: Image.asset(
                            "assets/images/logo.png",
                            width: mq.size.height * 0.3,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 250.0),
                        child: Text(
                          Strings.textBelowLogoDescription,
                          style: Styles.description(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Hero(
                          tag: HeroTags.explanation,
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              Strings.textTypePassword,
                              style: Styles.text(context),
                              textAlign: TextAlign.center,
                              softWrap: false,
                            ),
                          ),
                        ),
                        Hero(
                          tag: HeroTags.separator,
                          child: CSeparator(Colours.primaryColor),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                height: 51.0,
                                width: 60.0,
                                decoration: BoxDecoration(
                                  color: Colours.primaryColor,
                                  border: Border.all(color: Colors.black54),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Hero(
                                  tag: HeroTags.textField,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: TextFormField(
                                      focusNode: _passwordFocus,
                                      initialValue: _password,
                                      obscureText: true,
                                      onFieldSubmitted: (term) {
                                        _onValidateForm();
                                      },
                                      validator: (val) {
                                        _password = val;

                                        if (_password.length == 0) {
                                          return Strings.warnFillThisField;
                                        } else if (_password != Const.CORRECT_PASSWORD) {
                                          return Strings.warnInvalidPassword;
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(0),
                                            bottomLeft: Radius.circular(0),
                                            topRight: Radius.circular(5.0),
                                            bottomRight: Radius.circular(5.0),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(0),
                                            bottomLeft: Radius.circular(0),
                                            topRight: Radius.circular(5.0),
                                            bottomRight: Radius.circular(5.0),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.black54,
                                          ),
                                        ),
                                        contentPadding:
                                            EdgeInsets.only(left: 8.0, right: 8.0, top: 32.0),
                                        filled: true,
                                        fillColor: Colours.field,
                                        hintText: Strings.hintPassword,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5.0),
                                            bottomRight: Radius.circular(5.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16.0),
                          child: Hero(
                            tag: HeroTags.validateButton,
                            child: Material(
                              color: Colors.transparent,
                              child: CButton(
                                Strings.textValidate,
                                color: Colours.primaryColor,
                                onPressed: () {
                                  _onValidateForm();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 32.0),
                  child: Hero(
                    tag: HeroTags.cacfLogo,
                    child: Material(
                      color: Colors.transparent,
                      child: Image.asset(
                        "assets/images/cacf.png",
                        height: 30.0,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _isLogged() {
    return Cache.instance.getBool(Strings.cacheIsLogged) ?? false;
  }

  void _saveIsLogged() {
    Cache.instance.setBool(Strings.cacheIsLogged, true);
  }

  void _onValidateForm() {
    if (_formKey.currentState.validate()) {
      Page.dismissKeyboard(context);
      _onLogin();
    }
  }

  void _onLogin() {
    _saveIsLogged();
    Page.replacePage(context, StepsPage());
  }
}
