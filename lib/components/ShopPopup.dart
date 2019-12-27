import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/components/dropdownBtn.dart';
import 'package:c_valide/models/Region.dart';
import 'package:c_valide/models/Magasin.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:flutter/material.dart';

typedef ValueChangedCallback = void Function(
  Magasin filterMagasin,
);

class ShopPopup extends StatefulWidget {
  const ShopPopup({
    Key key,
    this.onValueChanged,
  }) : super(key: key);

  final ValueChangedCallback onValueChanged;

  @override
  ShopPopupState createState() => ShopPopupState();
}

class ShopPopupState extends State<ShopPopup> {
  List<Magasin> magasinArray;
  Magasin magasin;
  Region region;

  @override
  void initState() {
    super.initState();
    updateShopArray();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            height: 220,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colours.darkGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 75),
                  child: Column(
                    children: <Widget>[
                      DropdownBtn<Magasin>(
                        magasinArray
                            .map((e) => DropdownValue<Magasin>(e, e.name))
                            .toList(),
                        key: GlobalKey(),
                        value: magasin,
                        onValueChanged: (value) {
                          setState(() {
                            magasin = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width * 0.4,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5.0))),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            textColor: Colors.white,
                            color: Colors.black45,
                            child:
                                Text('Annuler', style: TextStyle(fontSize: 16)),
                            onPressed: () {
                              quitPage(context);
                            }),
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width * 0.4,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5.0)),
                          ),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          textColor: Colors.white,
                          color: Colors.black45,
                          child: Text(Strings.textValidate,
                              style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            if (widget.onValueChanged != null) {
                              widget.onValueChanged(
                                magasin.codeApporteur != '' ? magasin : null,
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateShopArray() {
    magasinArray = List<Magasin>.from(
      region == null || region.id < 0
          ? Registry.allData.unique.magasins.toList()
          : Registry.allData.unique.magasins
              .where((e) => e.regionId == region.id)
              .toList(),
    );
    magasinArray?.sort((e1, e2) => e1.name.compareTo(e2.name));
    magasinArray?.insert(
        0, Magasin(codeApporteur: '', name: Strings.textAllShops));
    magasin = magasinArray.first;
  }
}
