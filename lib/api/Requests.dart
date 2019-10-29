import 'package:c_valide/api/RestClient.dart';
import 'package:c_valide/app/Const.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Requests {
  static void isAdvisersAvailable(BuildContext context, {bool quitApp: true, VoidCallback onSuccess, VoidCallback onFailed}) {
    RestClient.fastTimeout.isAdvisersAvailable(Const.API_TOKEN).then((response) {
      if (response?.isAvailable ?? false) {
        if (onSuccess != null) {
          onSuccess();
        }
      } else {
        if (onFailed != null) {
          onFailed();
        }
        _showAdvisorsNonAvailableDialog(context, quitApp);
      }
    }).catchError((object) {
      _showAdvisorsNonAvailableDialog(context, quitApp);
    });
  }

  static void _showAdvisorsNonAvailableDialog(BuildContext context, [bool shouldQuitApp = true]) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                if (shouldQuitApp) {
                  quitApp();
                } else {
                  quitDialog(context);
                }
              },
              child: Text(shouldQuitApp ? 'Quitter' : 'Ok'),
            ),
          ],
          content: Text(Strings.textNoFreeAdvisor),
        );
      },
    );
  }
}
