import 'package:c_valide/FlavorConfig.dart';
import 'package:c_valide/main.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.FNAC,
    buildType: BuildType.STAGING,
    values: FlavorValues(
      appName: 'Validation dossier',
      flavorName: 'fnacStaging',
      apiBaseUrl: 'https://c-visite.fr/c-anomalie-add-on-r7/public/index.php/',
      fnacApiBaseUrl : 'https://sn-prod4.com/c-ouvert-recette/public/api/',
      enseigneId: 9,
      autoUpdateIdiOS: 'validation_dossier_ios',
      autoUpdateIdAndroid: 'validation_dossier_android',
    ),
  );

  runApp(MyApp());
}
