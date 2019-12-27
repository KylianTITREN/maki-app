import 'dart:io';

import 'package:c_valide/FlavorConfig.dart';
import 'package:c_valide/api/Requests.dart';
import 'package:c_valide/app/App.dart';
import 'package:c_valide/app/Const.dart';
import 'package:c_valide/autoupdate/AutoUpdate.dart';
import 'package:c_valide/autoupdate/VersionsClient.dart';
import 'package:c_valide/basics/BaseState.dart';
import 'package:c_valide/basics/BaseStatefulWidget.dart';
import 'package:c_valide/pages/StepsPage.dart';
import 'package:c_valide/res/HeroTags.dart';
import 'package:c_valide/res/Strings.dart';
import 'package:c_valide/utils/Dialogs.dart';
import 'package:c_valide/utils/Page.dart';
import 'package:c_valide/utils/System.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashscreenPage extends BaseStatefulWidget {
  @override
  State<StatefulWidget> onBuild() => SplashscreenPageState();
}

class SplashscreenPageState extends BaseState<SplashscreenPage> {
  static int _delay = 1500;
  int _requestsPending = 0;

  ChoicesDialog updateDialog;

  @override
  void initState() {
    super.initState();
    _startPackageInfoRequest(
      onSuccess: () {
        _startAutoUpdateRequest(
          onSuccess: () {
            _requestsPending = 0;
            _startTimer();
            _startDataRequest();
            if (kReleaseMode || Const.TEST_MODE) {
              _startAreServicesAvailableRequest();
            }
//          _startSharedPreferencesInitialization();
          },
        );
      },
      onFailed: () {
        ChoicesDialog(
          context,
          Text(Strings.textErrorOccurred),
          actions: {
            'Quitter': () {
              quitApp();
            }
          },
        ).show();
      },
    );
  }

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

  _startPackageInfoRequest({VoidCallback onSuccess, VoidCallback onFailed}) {
    System.getPackageInfo().then((packageInfo) {
      App.packageInfo = packageInfo;
      if (onSuccess != null) {
        onSuccess();
      }
    }).catchError((object) {
      print('Error: $object');
      if (onFailed != null) {
        onFailed();
      }
    });
  }

  _startAutoUpdateRequest({VoidCallback onSuccess}) {
    VersionsClient.service
        .autoUpdate(Platform.isIOS
            ? FlavorConfig.instance.values.autoUpdateIdiOS
            : FlavorConfig.instance.values.autoUpdateIdAndroid)
        .then((response) {
      _onAutoUpdate(response, onSuccess);
    }).catchError((object) {
      print('Error: $object');
      ChoicesDialog(
        context,
        Text('${Strings.textErrorOccurred}. ${Strings.textTryAgain}'),
        actions: <String, VoidCallback>{
          Strings.textTryAgain: () {
            quitDialog(context);
            _startAutoUpdateRequest(onSuccess: onSuccess);
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

  void _startAreServicesAvailableRequest() {
    _requestsPending++;
    Requests.areServicesAvailable(
      context,
      onSuccess: () {
        _onRequestsFinished();
      },
    );
  }

  _startDataRequest() {
    Requests.startAllDataRequest(
      context,
      onRequestFinished: _onRequestsFinished,
      onRequestError: () {
        --_requestsPending;
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

  _onAutoUpdate(AutoUpdate response, VoidCallback onSuccess) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String buildLocation = response.buildLocation;
    String servVersion = response.version;
    int servBuildNumber = response.buildNumber;
    int appBuildNumber = int.parse(App.packageInfo.buildNumber);

    int lastForcedBuildnumber = response.lastForcedBuildNumber;
    int appPrefsBuildNumber =
        prefs.getInt(Strings.prefNeverThisBuildNumberAgain) ?? 0;

    if (servBuildNumber <= appBuildNumber) {
      onSuccess();
    } else {
      bool ignored = appPrefsBuildNumber >= appBuildNumber;

      if (ignored) {
        onSuccess();
      } else {
        bool forced = lastForcedBuildnumber > appBuildNumber;

        Map<String, VoidCallback> actions = {};
        if (!forced) {
          actions['Plus tard'] = () {
            quitDialog(context);
            onSuccess();
          };

          actions['Jamais'] = () {
            quitDialog(context);
            prefs.setInt(
                Strings.prefNeverThisBuildNumberAgain, servBuildNumber);
            onSuccess();
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
    Platform.isIOS
        ? _downloadForIOS(buildLocation)
        : _downloadForAndroid(buildLocation);
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
