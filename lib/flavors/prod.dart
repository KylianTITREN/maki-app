import 'package:maki_app/FlavorConfig.dart';
import 'package:maki_app/main.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.PROD,
    buildType: BuildType.PRODUCTION,
    values: FlavorValues(
      appName: 'Maki App',
      flavorName: 'makiAppProd',
    ),
  );

  runApp(MyApp());
}
