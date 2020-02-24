import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maki_app/components/custom-button.dart';
import 'package:maki_app/components/custom-paragraph.dart';
import 'package:maki_app/components/header.dart';
import 'package:maki_app/components/skeleton.dart';
import 'package:maki_app/models/Recette.dart';
import 'package:maki_app/utils/Dialogs.dart';
import 'package:maki_app/utils/FirebaseUtils.dart';
import 'package:maki_app/utils/Page.dart';

typedef ValueChangedCallback = void Function(
  List<Recette> allRecettes,
);

class ShowRecettePage extends StatefulWidget {
  static get tag => '/Show-Recette';

  ShowRecettePage(this.recette, {this.onValueChanged});

  final Recette recette;
  final ValueChangedCallback onValueChanged;

  @override
  _ShowRecettePageState createState() =>
      _ShowRecettePageState(recette, onValueChanged: onValueChanged);
}

class _ShowRecettePageState extends State<ShowRecettePage> {
  _ShowRecettePageState(this._recette, {this.onValueChanged});

  Recette _recette;
  final ValueChangedCallback onValueChanged;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
      menuIcon: true,
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 45),
          child: Column(
            children: <Widget>[
              CustomHeader(
                icon: _recette.icon,
                title: _recette.name,
                func: null,
              ),
              SizedBox(height: 30),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _recette.hot != null
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Theme.of(context).accentColor,
                                  Color.fromRGBO(255, 206, 69, 1)
                                ],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              ),
                            ),
                            child: FlatButton.icon(
                                onPressed: null,
                                icon: Image.asset(
                                  'assets/images/fire-shape.png',
                                  width: 22,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  _recette.hot,
                                  style: TextStyle(color: Colors.white),
                                )))
                        : Container(),
                    SizedBox(width: 20),
                    _recette.time != null
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Theme.of(context).accentColor,
                                  Color.fromRGBO(255, 206, 69, 1)
                                ],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              ),
                            ),
                            child: FlatButton.icon(
                                onPressed: null,
                                icon: Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                ),
                                label: Text(_recette.time,
                                    style: TextStyle(color: Colors.white))),
                          )
                        : Container(),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        SizedBox(height: 25),
                        CustomParagraph(
                            title: 'Ingrédients',
                            ingredients: _recette.ingredients),
                        SizedBox(height: 30),
                        CustomParagraph(
                            title: 'Préparations', prepa: _recette.preparation),
                        SizedBox(height: 50),
                        CustomButton(
                          text: 'Supprimer',
                          bgColor: Colors.red,
                          func: () {
                            ChoicesDialog(
                              context,
                              Text(
                                  'Grrrr, tu es sûre de vouloir supprimer cette (succulente) recette ?'),
                              actions: <String, VoidCallback>{
                                'Annuler': () {
                                  quitDialog(context);
                                },
                                'Supprimer': () {
                                  quitDialog(context);
                                  FirebaseUtils.deleteRecette(_recette.uid,
                                      callback: (allRecettes) {
                                    toast('Recette supprimée ! ✅');
                                    onValueChanged(allRecettes);
                                    Timer(Duration(seconds: 1),
                                        () => quitPage(context));
                                  });
                                }
                              },
                            ).show();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
