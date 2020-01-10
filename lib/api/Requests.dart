import 'package:c_valide/api/RestClient.dart';
import 'package:c_valide/app/Const.dart';
import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/models/Magasin.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/utils/Dialogs.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Requests {
  static const int MAX_ATTEMPTS = 3;

  static void isChatAvailable(BuildContext context,
      {bool quitApp: true, VoidCallback onSuccess, VoidCallback onFailed}) {
    RestClient.fastTimeout.isChatAvailable().then((response) {
      bool isAvailable = response?.activated;
      print('Message is active ? : $isAvailable');

      Registry.activeMessage = isAvailable;
    });
  }

  static void getMobileDelay(BuildContext context,
      {bool quitApp: true, VoidCallback onSuccess, VoidCallback onFailed}) {
    RestClient.fastTimeout.getMobileDelay().then((response) {
      int mobileDelay = response?.delay;

      if (response != null || mobileDelay != null || mobileDelay != 0) {
        print('Delay is update to : $mobileDelay');
        Registry.mobileDelay = mobileDelay;
        onSuccess();
      } else {
        print('Delay is to default');
        onFailed();
      }
    });
  }

  static void getShop(BuildContext context,
      {int attempts = 0,
      VoidCallback onPositive,
      VoidCallback onNegative,
      VoidCallback onSuccess,
      VoidCallback onFailed}) {
    RestClient.fastTimeout.getShop(Const.API_TOKEN, 9)
      ..then((response) {
        List<Magasin> allShops = response?.magasins;
        if (allShops != null || allShops.isNotEmpty) {
          Registry.allShop = allShops;
          if (onSuccess != null) {
            onSuccess();
          }
        }
      }).catchError((Object object) {
        if (attempts < MAX_ATTEMPTS) {
          getShop(context,
              attempts: attempts + 1,
              onSuccess: onSuccess,
              onFailed: onFailed,
              onNegative: onNegative,
              onPositive: onPositive);
        } else {
          ChoiceDialog(
            context,
            Strings.textErrorOccurredTryAgain,
            positive: Text(Strings.textTryAgain),
            negative: Text(Strings.textQuit),
            onPositive: () {
              quitDialog(context);
              onPositive ??
                  getShop(context,
                      attempts: attempts,
                      onSuccess: onSuccess,
                      onFailed: onFailed,
                      onNegative: onNegative,
                      onPositive: onPositive);
            },
            onNegative: () {
                onNegative ?? quitApp();
            },
          ).show();

          print('Error: $object');

          if (onFailed != null) {
            onFailed();
          }
        }
      });
  }

  static void areServicesAvailable(BuildContext context,
      {bool quitApp: true, VoidCallback onSuccess, VoidCallback onFailed}) {
    RestClient.fastTimeout
        .areServicesAvailable(Const.API_TOKEN)
        .then((response) {
      bool isAvailable = response?.isAvailable ?? false;
      bool isOpenHours = response?.isOpenHours ?? false;

      print('Is available: $isAvailable');
      print('Is open hours: $isOpenHours');

      if (!isAvailable) {
        if (onFailed != null) {
          onFailed();
        }
        Registry.activeShop = false;
        _showNonAvailableDialog(context, Strings.textNoFreeAdvisor, quitApp);
      } else if (!isOpenHours) {
        if (onFailed != null) {
          onFailed();
        }
        Registry.activeShop = false;
        _showNonAvailableDialog(
            context, Strings.textServiceAvailableBetween, quitApp);
      } else {
        if (onSuccess != null) {
          onSuccess();
        }
      }
    }).catchError((object) {
      print('Error: $object');
      if (onFailed != null) {
        onFailed();
      }
      Registry.activeShop = false;
      _showNonAvailableDialog(context, Strings.textErrorOccurred, quitApp);
    });
  }

  static void _showNonAvailableDialog(BuildContext context, String message,
      [bool shouldQuitApp = true]) {
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
          content: Text(message),
        );
      },
    );
  }
}
