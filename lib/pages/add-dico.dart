import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maki_app/app/Registry.dart';
import 'package:maki_app/components/custom-button.dart';
import 'package:maki_app/components/custom-dropdown.dart';
import 'package:maki_app/components/custom-input.dart';
import 'package:maki_app/models/Dico.dart';
import 'package:maki_app/utils/FirebaseUtils.dart';
import 'package:maki_app/utils/Page.dart';

typedef ValueChangedCallback = void Function(
  List<Dico> allDico,
);

class AddDicoModal extends StatefulWidget {
  AddDicoModal({this.onValueChanged});

  final ValueChangedCallback onValueChanged;

  @override
  _AddDicoModalState createState() => _AddDicoModalState(onValueChanged);
}

class _AddDicoModalState extends State<AddDicoModal> {
  _AddDicoModalState(this.onValueChanged);

  final _formKey = GlobalKey<FormState>();

  String from;
  String word;

  String showedName = 'Sélectionner';

  final ValueChangedCallback onValueChanged;

  static final TextEditingController _fromieldController =
      TextEditingController();
  static final TextEditingController _wordFieldController =
      TextEditingController();

  void clean() {
    _fromieldController.clear();
    _wordFieldController.clear();

    quitPage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      CustomDropdown(
                        'De',
                        Registry.allNames,
                        showedName,
                        _fromieldController,
                        mandatory: true,
                        onValueChanged: (name) {
                          setState(() {
                            from = name;
                            showedName = name;
                          });
                        },
                      ),
                      CustomInput(
                        'Mot / Phrase',
                        'Makichan',
                        _wordFieldController,
                        mandatory: true,
                        nbLines: 3,
                        onValueChanged: (newWord) {
                          setState(() {
                            word = newWord;
                          });
                        },
                      ),
                      SizedBox(height: 30),
                      CustomButton(
                        text: 'Ajouter',
                        func: () {
                          if (_formKey.currentState.validate()) {
                            FirebaseUtils.createDico(from, word);
                            toast('Phrase ajoutée avec succès ✅');
                            onValueChanged(Registry.allDico);
                            Timer(Duration(seconds: 1), () => clean());
                          }
                        },
                      ),
                      SizedBox(
                          height: 20 + MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
