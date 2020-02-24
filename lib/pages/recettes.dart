import 'package:flutter/material.dart';
import 'package:maki_app/app/Registry.dart';
import 'package:maki_app/components/bottom-sheet.dart';
import 'package:maki_app/components/card.dart';
import 'package:maki_app/components/header.dart';
import 'package:maki_app/components/skeleton.dart';
import 'package:maki_app/models/Recette.dart';
import 'package:maki_app/pages/add-recette.dart';
import 'package:maki_app/pages/show-recette.dart';
import 'package:maki_app/utils/FirebaseUtils.dart';
import 'package:maki_app/utils/Page.dart';

class RecettesPage extends StatefulWidget {
  static get tag => '/Recettes';

  @override
  _RecettesPageState createState() => _RecettesPageState();
}

class _RecettesPageState extends State<RecettesPage> {
  List<Recette> _allRecettes;

  @override
  void initState() {
    FirebaseUtils.getRecettes();
    setState(() {
      _allRecettes = Registry.allRecettes;
    });
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
                icon: '🍔',
                title: 'maki recettes',
                func: () async {
                  await showModalBottomSheet<int>(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return BottomSheetComponent(
                          icon: '🍔',
                          title: 'Ajoute ta recette',
                          child: AddRecetteModal(
                            onValueChanged: (newAllRecettes) {
                              setState(() {
                                _allRecettes = newAllRecettes;
                              });
                            },
                          ),
                        );
                      });
                },
              ),
              SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: _allRecettes != null
                          ? _allRecettes
                              .map((data) => Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: CustomCard(
                                      icon: data.icon,
                                      title: data.name,
                                      func: () => startPage(
                                          context,
                                          ShowRecettePage(data,
                                              onValueChanged:
                                                  (newAllRecettes) {
                                                    setState(() {
                                                      _allRecettes = newAllRecettes;
                                                    });
                                                  })),
                                    ),
                                  ))
                              .toList()
                          : [],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
