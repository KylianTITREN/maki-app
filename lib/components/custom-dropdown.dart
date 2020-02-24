import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maki_app/res/Styles.dart';

typedef ValueChangedCallback = void Function(
  String selectedEmoji,
);

class CustomDropdown extends StatelessWidget {
  CustomDropdown(this.label, this.list, this.placeholder, this.controller,
      {this.sublabel, this.mandatory, this.nbLines, this.extentSize, this.fsize, this.onValueChanged});

  final String label;
  final String sublabel;
  final bool mandatory;
  final int nbLines;
  final double fsize;
  final double extentSize;
  final List<String> list;
  final String placeholder;
  final ValueChangedCallback onValueChanged;
  final TextEditingController controller;

  String _selectedEmoji;
  int _selectedNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label + (mandatory == true ? ' *' : ''),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                sublabel != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Opacity(
                          opacity: 0.6,
                          child: Text(
                            sublabel,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 9),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              boxShadow: [
                new BoxShadow(
                    color: Colors.black12,
                    offset: new Offset(0.0, 0.0),
                    blurRadius: 13)
              ],
            ),
            child: TextFormField(
              controller: controller,
              readOnly: true,
              decoration: Styles.formField(context,
                  placeholder: placeholder, dropdown: true),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 300.0,
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CupertinoButton(
                            child: Text("Fermer", style: TextStyle(color: Theme.of(context).accentColor),),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController: new FixedExtentScrollController(
                                initialItem: _selectedNumber,
                              ),
                              itemExtent: extentSize ??45,
                              backgroundColor: Colors.white,
                              onSelectedItemChanged: (int index) {
                                _selectedEmoji = list[index];
                              },
                              children: list
                                  .map((item) => Padding(
                                    padding: const EdgeInsets.only(top:10),
                                    child: new Text(
                                          item.toString(),
                                          style: TextStyle(fontSize: fsize ?? null),
                                        ),
                                  ))
                                  .toList(),
                            ),
                          ),
                          CupertinoButton(
                            child: Text("Ok", style: TextStyle(color: Theme.of(context).accentColor),),
                            onPressed: () {
                              controller.text = _selectedEmoji;
                              onValueChanged(_selectedEmoji);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              validator: (dropdownValue) {
                if (mandatory != null && mandatory == true) {
                  if (dropdownValue.isEmpty) {
                    return 'Sélectionne une valeur';
                  }
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
