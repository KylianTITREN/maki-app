import 'package:c_valide/FlavorConfig.dart';
import 'package:c_valide/main.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.FNAC,
    buildType: BuildType.PRODUCTION,
    values: FlavorValues(
      appName: 'Validation dossier',
      flavorName: 'fnacProduction',
      apiBaseUrl: 'https://c-visite.fr/c-anomalie-add-on/public/index.php/',
      enseigneId: 9,
      autoUpdateIdiOS: 'validation_dossier_ios',
      autoUpdateIdAndroid: 'validation_dossier_android',
    ),
  );

  runApp(MyApp());
}
