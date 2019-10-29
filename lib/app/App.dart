import 'dart:io';

import 'package:c_valide/utils/Dialogs.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class App {
  static PackageInfo packageInfo;

  static Future<Map<String, String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform informations');
    }

    return <String, String>{
      'NAME': deviceName,
      'VERSION': deviceVersion,
      'ID': identifier,
    };
  }

  static Future<dynamic> onNotificationReceived(BuildContext context, Map<String, dynamic> message) async {
    if (message.containsKey('notification')) {
      final dynamic notification = message['notification'];

      InformationDialog(
        context,
        text: notification['body'],
      ).show();
    }
  }
}
