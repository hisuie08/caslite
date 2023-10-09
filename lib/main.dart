import 'package:caslite/caslite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// ignore: missing_provider_scope
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );
  await SharedPreferencesInstance.initialize();
  await AppInfo.engage();
  runApp(ProviderScope(
    child: const CasliteApp(),
  ));
}

class AppInfo {
  static late final PackageInfo _packageInfo;
  PackageInfo get package => _packageInfo;
  static final AppInfo _appInfo = AppInfo._internal();
  AppInfo._internal();
  factory AppInfo() => _appInfo;
  static engage() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }
}

class SharedPreferencesInstance {
  static late final SharedPreferences _pref;
  SharedPreferences get pref => _pref;

  static final SharedPreferencesInstance _instance =
      SharedPreferencesInstance._internal();

  SharedPreferencesInstance._internal();

  factory SharedPreferencesInstance() => _instance;

  static initialize() async {
    _pref = await SharedPreferences.getInstance();
  }
}
