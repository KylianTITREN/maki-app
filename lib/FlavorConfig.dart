import 'package:c_valide/utils/StringUtils.dart';
import 'package:flutter/material.dart';

enum Flavor { FNAC }
enum BuildType { LOCAL, STAGING, PRODUCTION }

class FlavorValues {
  FlavorValues({
    this.appName,
    this.flavorName,
    this.apiBaseUrl,
    this.fnacApiBaseUrl,
    this.enseigneId,
    this.autoUpdateIdiOS,
    this.autoUpdateIdAndroid,
  });

  final String appName;
  final String flavorName;
  final String apiBaseUrl;
  final String fnacApiBaseUrl;
  final int enseigneId;
  final String autoUpdateIdiOS;
  final String autoUpdateIdAndroid;
}

class FlavorConfig {
  final Flavor flavor;
  final BuildType buildType;
  final String name;
  final Color color;
  final FlavorValues values;
  static FlavorConfig _instance;

  factory FlavorConfig({@required Flavor flavor, @required BuildType buildType, Color color: Colors.blue, @required FlavorValues values}) {
    _instance ??= FlavorConfig._internal(
      flavor,
      buildType,
      StringUtils.enumName(buildType.toString()),
      color,
      values,
    );
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.buildType, this.name, this.color, this.values);

  static FlavorConfig get instance {
    return _instance;
  }

  static bool isProduction() => _instance.buildType == BuildType.PRODUCTION;

  static bool isStaging() => _instance.buildType == BuildType.STAGING;

  static bool isLocal() => _instance.buildType == BuildType.LOCAL;
}
