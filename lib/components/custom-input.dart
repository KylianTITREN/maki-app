import 'package:flutter/material.dart';
import 'package:maki_app/res/Styles.dart';

typedef ValueChangedCallback = void Function(
  String content,
);

class CustomInput extends StatelessWidget {
  CustomInput(this.label, this.placeholder, this.controller, {this.sublabel, this.mandatory, this.nbLines, this.onValueChanged});

  final String label;
  final String sublabel;
  final bool mandatory;
  final int nbLines;
  final String placeholder;
  final ValueChangedCallback onValueChanged;
  final TextEditingController controller;

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
              maxLines: nbLines ?? 1,
              controller: controller,
              decoration: Styles.formField(context, placeholder: placeholder),
              onChanged: (inputValue){
                onValueChanged(inputValue);
              },
              validator: (inputValue) {
                if (mandatory != null && mandatory == true) {
                  if (inputValue.isEmpty) {
                    return 'Entre une valeur';
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
