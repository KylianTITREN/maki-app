import 'package:flutter/material.dart';
import 'package:maki_app/app/Registry.dart';
import 'package:maki_app/components/bottom-sheet.dart';
import 'package:maki_app/components/header.dart';
import 'package:maki_app/components/skeleton.dart';
import 'package:maki_app/models/Dico.dart';
import 'package:maki_app/pages/add-dico.dart';
import 'package:maki_app/utils/FirebaseUtils.dart';

class DicoPage extends StatefulWidget {
  static get tag => '/Dico';

  @override
  _DicoPageState createState() => _DicoPageState();
}

class _DicoPageState extends State<DicoPage> {
  List<Dico> _allDico;

  @override
  void initState() {
    FirebaseUtils.getDico();
    setState(() {
      _allDico = Registry.allDico;
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
              icon: '📖',
              title: 'maki dico',
              func: () async {
                await showModalBottomSheet<int>(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return BottomSheetComponent(
                        icon: '📖',
                        title: 'Ajoute ton mot',
                        child: AddDicoModal(
                          onValueChanged: (newAllDico) {
                            setState(() {
                               _allDico = newAllDico;
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
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _allDico != null
                        ? _allDico
                            .map((data) => Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, bottom: 20),
                                      child: Text(
                                        data.from.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: data.words
                                          .map(
                                            (word) => Opacity(
                                              opacity: 0.6,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: Text(
                                                  word,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    )
                                  ],
                                )))
                            .toList()
                        : [],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
