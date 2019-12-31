import 'package:c_valide/api/COuvertClient.dart';
import 'package:c_valide/api/RestClient.dart';
import 'package:c_valide/app/Const.dart';
import 'package:c_valide/app/Registry.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/utils/Dialogs.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Requests {
  static const int MAX_ATTEMPTS = 3;

  static startAllDataRequest(
    BuildContext context, {
    String description,
    String positive,
    String negative,
    VoidCallback onRequestFinished,
    VoidCallback onRequestError,
    VoidCallback onPositive,
    VoidCallback onNegative,
    int filterRegion,
    int filterAgence,
    int filterSecteur,
    int attempts = 0,
  }) {
    COuvertClient.service.getAllData(
      9,
      regionId: filterRegion != null && filterRegion > 0 ? filterRegion : null,
      agenceId: filterAgence != null && filterAgence > 0 ? filterAgence : null,
      secteurId: filterSecteur != null && filterSecteur > 0 ? filterSecteur : null,
    )..then((allData) {
        Registry.allData = allData;

        if (onRequestFinished != null) {
          onRequestFinished();
        }
      }).catchError((Object object) {
        if (attempts < MAX_ATTEMPTS) {
          startAllDataRequest(
            context,
            attempts: attempts + 1,
            onRequestError: onRequestError,
            onNegative: onNegative,
            onRequestFinished: onRequestFinished,
            description: description,
            filterAgence: filterAgence,
            filterRegion: filterRegion,
            filterSecteur: filterSecteur,
            negative: negative,
            onPositive: onPositive,
            positive: positive,
          );
        } else {
          ChoiceDialog(
            context,
            description ?? Strings.textErrorOccurredTryAgain,
            positive: Text(positive ?? Strings.textTryAgain),
            negative: Text(negative ?? Strings.textQuit),
            onPositive: () {
              quitDialog(context);
              onPositive ??
                  startAllDataRequest(
                    context,
                    attempts: attempts,
                    onRequestError: onRequestError,
                    onNegative: onNegative,
                    onRequestFinished: onRequestFinished,
                    description: description,
                    filterAgence: filterAgence,
                    filterRegion: filterRegion,
                    filterSecteur: filterSecteur,
                    negative: negative,
                    onPositive: onPositive,
                    positive: positive,
                  );
            },
            onNegative: () {
              onNegative ?? quitApp();
            },
          ).show();

          print('Error: $object');

          if (onRequestError != null) {
            onRequestError();
          }
        }
      });
  }

  static void isChatAvailable(BuildContext context, {bool quitApp: true, VoidCallback onSuccess, VoidCallback onFailed}){
    RestClient.fastTimeout.isChatAvailable().then((response){
      bool isAvailable = response?.activated;

      print('Message is active ? : $isAvailable');

      Registry.activeMessage = isAvailable;
    });
  }

  static void areServicesAvailable(BuildContext context, {bool quitApp: true, VoidCallback onSuccess, VoidCallback onFailed}) {
    RestClient.fastTimeout.areServicesAvailable(Const.API_TOKEN).then((response) {
      bool isAvailable = response?.isAvailable ?? false;
      bool isOpenHours = response?.isOpenHours ?? false;

      print('Is available: $isAvailable');
      print('Is open hours: $isOpenHours');

      if (!isAvailable) {
        if (onFailed != null) {
          onFailed();
        }
        _showNonAvailableDialog(context, Strings.textNoFreeAdvisor, quitApp);
      } else if (!isOpenHours) {
        if (onFailed != null) {
          onFailed();
        }
        _showNonAvailableDialog(context, Strings.textServiceAvailableBetween, quitApp);
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
      _showNonAvailableDialog(context, Strings.textErrorOccurred, quitApp);
    });
  }

  static void _showNonAvailableDialog(BuildContext context, String message, [bool shouldQuitApp = true]) {
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
