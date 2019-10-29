import 'dart:io';

import 'package:c_valide/FlavorConfig.dart';
import 'package:c_valide/api/Requests.dart';
import 'package:c_valide/app/App.dart';
import 'package:c_valide/app/Const.dart';
import 'package:c_valide/autoupdate/AutoUpdate.dart';
import 'package:c_valide/autoupdate/VersionsClient.dart';
import 'package:c_valide/basics/BaseStatelessWidget.dart';
import 'package:c_valide/pages/StepsPage.dart';
import 'package:c_valide/res/HeroTags.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/utils/Dialogs.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashscreenPage extends BaseStatelessWidget {
  static int _delay = 1500;
  int _requestsPending = 0;

  ChoicesDialog updateDialog;

  @override
  Widget onBuild() {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Center(
          child: Hero(
            tag: HeroTags.logo,
            child: Material(
              color: Colors.transparent,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.fitWidth,
                width: mq.size.width * 0.6,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onCreate() {
    _requestsPending = 0;
    _startAutoUpdateRequest(() {
      if (App.serviceOpened(context)) {
        _startTimer();
        if (kReleaseMode || Const.DEMO) {
          _startIsAdvisersAvailableRequest();
//      _startIsServiceAvailableRequest();
        }
//    _startSharedPreferencesInitialization();
      }
    });
  }

  _startAutoUpdateRequest(VoidCallback onFailed) {
    VersionsClient.service
        .autoUpdate(Platform.isIOS ? FlavorConfig.instance.values.autoUpdateIdiOS : FlavorConfig.instance.values.autoUpdateIdAndroid)
        .then((response) {
      _onAutoUpdate(response, onFailed);
    }).catchError((object) {
      ChoicesDialog(
        context,
        Text('${Strings.textErrorOccurred}. ${Strings.textTryAgain}'),
        actions: <String, VoidCallback>{
          Strings.textTryAgain: () {
            quitDialog(context);
            _startAutoUpdateRequest(onFailed);
          },
          Strings.textQuit: () {
            quitApp();
          }
        },
      ).show();
    });
  }

  void _startTimer() {
    _requestsPending++;
    delay(() {
      _onRequestsFinished();
    }, _delay);
  }

  void _startIsAdvisersAvailableRequest() {
    _requestsPending++;
    Requests.isAdvisersAvailable(
      context,
      onSuccess: () {
        _onRequestsFinished();
      },
    );
  }

//  void _startSharedPreferencesInitialization() {
//    _requestsPending++;
//    initializeSharedPreferences(() {
//      _onRequestsFinished();
//    });
//  }

  void _onRequestsFinished() {
    if (--_requestsPending == 0) {
      replacePage(context, StepsPage());
    }
  }

  _onAutoUpdate(AutoUpdate response, VoidCallback onFailed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String buildLocation = response.buildLocation;
    String servVersion = response.version;
    int servBuildNumber = response.buildNumber;
    int appBuildNumber = int.parse(App.packageInfo.buildNumber);

    int lastForcedBuildnumber = response.lastForcedBuildNumber;
    int appPrefsBuildNumber = prefs.getInt(Strings.prefNeverThisBuildNumberAgain) ?? 0;

    if (servBuildNumber <= appBuildNumber) {
      _onRequestsFinished();
    } else {
      bool ignored = appPrefsBuildNumber >= appBuildNumber;

      if (ignored) {
        onFailed();
      } else {
        bool forced = lastForcedBuildnumber > appBuildNumber;

        Map<String, VoidCallback> actions = {};
        if (!forced) {
          actions['Plus tard'] = () {
            quitDialog(context);
            onFailed();
          };

          actions['Jamais'] = () {
            quitDialog(context);
            prefs.setInt(Strings.prefNeverThisBuildNumberAgain, servBuildNumber);
            onFailed();
          };
        }

        actions['Mettre à jour'] = () {
          quitDialog(context);
          _updateApp(buildLocation);
        };

        updateDialog?.dismiss();

        updateDialog = ChoicesDialog(
          context,
          Text(
            forced
                ? 'Une mise à jour est disponible ($servVersion). Veuillez mettre à jour pour continuer'
                : "Une mise à jour est disponible ($servVersion). Voulez-vous mettre à jour l'application ?",
          ),
          actions: actions,
        );

        updateDialog?.show();
      }
    }
  }

  _updateApp(String buildLocation) {
    Platform.isIOS ? _downloadForIOS(buildLocation) : _downloadForAndroid(buildLocation);
  }

  void _downloadForIOS(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ChoicesDialog(
        context,
        Text(Strings.textDownloadFailed),
        actions: <String, VoidCallback>{
          Strings.textTryAgain: () {
            quitDialog(context);
            return _downloadForIOS(url);
          },
          Strings.textQuit: () {
            quitApp();
          }
        },
      ).show();
    }
  }

  void _downloadForAndroid(String url) async {
    Directory parentDir = await getExternalStorageDirectory();

    // Download the app
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: parentDir.path,
      headers: <String, String>{
        'Content-Type': 'application/vnd.android.package-archive',
      },
    );

    FlutterDownloader.registerCallback((id, status, progress) {
      if (taskId != null && id == taskId) {
        if (status == DownloadTaskStatus.complete) {
          // Install the app
          FlutterDownloader.open(taskId: taskId);
        } else if (status == DownloadTaskStatus.running) {
          print('Progress: $progress');
        } else if (status == DownloadTaskStatus.failed) {
          ChoicesDialog(
            context,
            Text(Strings.textDownloadFailed),
            actions: <String, VoidCallback>{
              Strings.textTryAgain: () {
                quitDialog(context);
                return _downloadForAndroid(url);
              },
              Strings.textQuit: () {
                quitApp();
              }
            },
          ).show();
        }
      }
    });
  }
}
