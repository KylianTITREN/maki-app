import 'package:maki_app/FlavorConfig.dart';
import 'package:maki_app/main.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.DEV,
    buildType: BuildType.STAGING,
    values: FlavorValues(
      appName: 'Maki App',
      flavorName: 'makiAppDev',
    ),
  );

  runApp(MyApp());
}
