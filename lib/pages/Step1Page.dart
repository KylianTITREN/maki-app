import 'package:c_valide/app/Const.dart';
import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/basics/BaseState.dart';
import 'package:c_valide/basics/BaseStatefulWidget.dart';
import 'package:c_valide/components/CButton.dart';
import 'package:c_valide/components/CSeparator.dart';
import 'package:c_valide/pages/StepsPage.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/res/HeroTags.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/res/Styles.dart';
import 'package:c_valide/utils/FirebaseUtils.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:flutter/material.dart';

class StepPage1 extends BaseStatefulWidget {
  StepPage1(this.parentState);

  final StepsPageState parentState;

  @override
  State<StatefulWidget> onBuild() => _StepPage1State();
}

class _StepPage1State extends BaseState<StepPage1> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _passwordFocus = FocusNode();

  @override
  Widget onBuild() {
    if (Const.FAST_MODE_ENABLED) {
      Registry.folderNumber = '12345678901';
    }

    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Hero(
                  tag: HeroTags.explanation,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      Strings.textInsertFolderNumber,
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
                  margin: EdgeInsets.only(top: 24.0),
                  child: Hero(
                    tag: HeroTags.textField,
                    child: Material(
                      color: Colors.transparent,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: Const.MAX_FOLDER_NUMBER_LENGTH,
                        textAlign: TextAlign.center,
                        focusNode: _passwordFocus,
                        initialValue: Registry.folderNumber,
                        onFieldSubmitted: (term) {
                          _onValidateForm();
                        },
                        validator: (val) {
                          Registry.folderNumber = val;

                          if (Registry.folderNumber.length == 0) {
                            return Strings.warnFillThisField;
                          } else if (Registry.folderNumber.length <
                              Const.MAX_FOLDER_NUMBER_LENGTH) {
                            return Strings.warnFolderNumberInvalid;
                          }

                          return null;
                        },
                        decoration: InputDecoration(
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
                          hintText: Strings.hintFolderNumber,
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
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  child: Hero(
                    tag: HeroTags.validateButton,
                    child: Material(
                      color: Colors.transparent,
                      child: CButton(
                        Strings.textValidate,
                        color: Colours.primaryColor,
                        onPressed: _onValidateForm,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onValidateForm() {
    if (_formKey.currentState.validate()) {
      Page.dismissKeyboard(context);
      _onValidate();
    }
  }

  void _onValidate() {
    FirebaseUtils.createFolder(Registry.folderNumber, callback: (String uid) {
      Registry.uid = uid;
      widget.parentState.goToNextPage();
    });
  }
}
