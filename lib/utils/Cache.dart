import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future initializeSharedPreferences([VoidCallback callback]) async {
  await SharedPreferences.getInstance().then((SharedPreferences prefs) {
    Cache.instance = prefs;
    if (callback != null) {
      callback();
    }
  });
}

class Cache {
  static SharedPreferences instance;
}
