import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/models/Anomalie.dart';
import 'package:c_valide/res/Colours.dart';
import 'package:c_valide/res/Styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnomalieRow extends StatelessWidget {
  AnomalieRow(this.anomalie);

  final Anomalie anomalie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: anomalie.isResolved || !anomalie.pictureNeeded ? Colours.primaryColor : Colours.darkGrey,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              anomalie.nom,
              style: Styles.textThin(context),
            ),
          ),
          Icon(
            anomalie.isResolved || !anomalie.pictureNeeded ? Icons.check : Icons.keyboard_arrow_right,
            color: Registry.folderValidated == 1 ? Colors.transparent : Colors.white,
          ),
        ],
      ),
    );
  }
}