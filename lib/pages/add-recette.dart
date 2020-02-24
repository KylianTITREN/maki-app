import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maki_app/app/Registry.dart';
import 'package:maki_app/components/custom-button.dart';
import 'package:maki_app/components/custom-dropdown.dart';
import 'package:maki_app/components/custom-input.dart';
import 'package:maki_app/models/Recette.dart';
import 'package:maki_app/utils/FirebaseUtils.dart';
import 'package:maki_app/utils/Page.dart';

typedef ValueChangedCallback = void Function(
  List<Recette> allRecette,
);

class AddRecetteModal extends StatefulWidget {
  AddRecetteModal({this.onValueChanged});

  final ValueChangedCallback onValueChanged;

  @override
  _AddRecetteModalState createState() => _AddRecetteModalState(onValueChanged);
}

class _AddRecetteModalState extends State<AddRecetteModal> {
  _AddRecetteModalState(this.onValueChanged);

  final ValueChangedCallback onValueChanged;

  final _formKey = GlobalKey<FormState>();

  String icon;
  String name;
  String ingredients;
  String preparation;
  String time;
  String hot;

  String showedIcon = 'Sélectionner';
  List<String> icons = [
    '🍏',
    '🍎',
    '🍐',
    '🍊',
    '🍋',
    '🍌',
    '🍉',
    '🍇',
    '🍓',
    '🍈',
    '🍒',
    '🍑',
    '🍍',
    '🥭',
    '🥥',
    '🥝',
    '🍅',
    '🍆',
    '🥑',
    '🥦',
    '🥒',
    '🥬',
    '🌶',
    '🌽',
    '🥕',
    '🥔',
    '🍠',
    '🥐',
    '🍞',
    '🥖',
    '🥨',
    '🥯',
    '🧀',
    '🥚',
    '🍳',
    '🥞',
    '🥓',
    '🥩',
    '🍗',
    '🍖',
    '🌭',
    '🍔',
    '🍟',
    '🍕',
    '🥪',
    '🥙',
    '🌮',
    '🌯',
    '🥗',
    '🥘',
    '🥫',
    '🍝',
    '🍜',
    '🍲',
    '🍛',
    '🍣',
    '🍱',
    '🥟',
    '🍤',
    '🍙',
    '🍚',
    '🍘',
    '🍥',
    '🥮',
    '🥠',
    '🍢',
    '🍡',
    '🍧',
    '🍨',
    '🍦',
    '🥧',
    '🍰',
    '🎂',
    '🍮',
    '🍭',
    '🍬',
    '🍫',
    '🍿',
    '🧂',
    '🍩',
    '🍪',
    '🌰',
    '🥜',
    '🍯',
    '🥛',
    '🍼',
    '☕️',
    '🍵',
    '🥤',
    '🍶',
    '🍺',
    '🍻',
    '🥂',
    '🍷',
    '🥃',
    '🍸',
    '🍹',
    '🍾',
    '🥄',
    '🍴',
    '🍽',
    '🥣',
    '🥡',
    '🥢'
  ];

  static final TextEditingController _iconFieldController =
      TextEditingController();
  static final TextEditingController _nameFieldController =
      TextEditingController();
  static final TextEditingController _ingredientsFieldController =
      TextEditingController();
  static final TextEditingController _preparationFieldController =
      TextEditingController();
  static final TextEditingController _timeFieldController =
      TextEditingController();
  static final TextEditingController _hotFieldController =
      TextEditingController();

  void clean() {
    _iconFieldController.clear();
    _nameFieldController.clear();
    _ingredientsFieldController.clear();
    _preparationFieldController.clear();
    _timeFieldController.clear();
    _hotFieldController.clear();

    FirebaseUtils.getRecettes();

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
                        'Choisis une icon',
                        icons,
                        showedIcon,
                        _iconFieldController,
                        mandatory: true,
                        fsize: 40,
                        extentSize: 73,
                        onValueChanged: (newIcon) {
                          setState(() {
                            icon = newIcon;
                            showedIcon = newIcon;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 90),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        ),
                      ),
                      CustomInput(
                        'Nom',
                        'Maki au barbecue',
                        _nameFieldController,
                        mandatory: true,
                        onValueChanged: (newName) {
                          setState(() {
                            name = newName;
                          });
                        },
                      ),
                      CustomInput(
                        'Ingrédients',
                        'Chat; allume feu…',
                        _ingredientsFieldController,
                        mandatory: true,
                        nbLines: 5,
                        sublabel:
                            '(séparer les ingrédients par des points virgules)',
                        onValueChanged: (newIngredients) {
                          setState(() {
                            ingredients = newIngredients;
                          });
                        },
                      ),
                      CustomInput(
                        'Préparation',
                        'Assomer le chat; allumer le feu; déposer le chat dans le feu; laisser mijoter… ',
                        _preparationFieldController,
                        mandatory: true,
                        nbLines: 5,
                        sublabel:
                            '(séparer les étapes par des points virgules)',
                        onValueChanged: (newPreparation) {
                          setState(() {
                            preparation = newPreparation;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 90),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        ),
                      ),
                      CustomInput(
                        'Temps de cuisson',
                        '1 minute par maki',
                        _hotFieldController,
                        onValueChanged: (newHot) {
                          setState(() {
                            hot = newHot;
                          });
                        },
                      ),
                      CustomInput(
                        'Temps de préparation',
                        '30s',
                        _timeFieldController,
                        onValueChanged: (newTime) {
                          setState(() {
                            time = newTime;
                          });
                        },
                      ),
                      SizedBox(height: 30),
                      CustomButton(
                        text: 'Ajouter',
                        func: () {
                          if (_formKey.currentState.validate()) {
                            FirebaseUtils.createRecette(
                              icon,
                              name,
                              preparation,
                              ingredients: ingredients,
                              hot: hot,
                              time: time,
                            );
                            toast('Recette ajoutée avec succès ✅');
                            onValueChanged(Registry.allRecettes);
                            Timer(Duration(seconds: 1), () => clean());
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
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
