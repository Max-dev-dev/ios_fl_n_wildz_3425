import 'package:flutter/material.dart';
import 'package:ios_fl_n_wildatlas_3425/app.dart';
import 'package:ios_fl_n_wildatlas_3425/ver_screen.dart';

class AppConstants {
  static const String oneSignalAppId = "7f547ec8-ef62-4712-a099-41645736d1f4";
  static const String appsFlyerDevKey = "v7xCW2oiGJ5JauPXwWiS5W";
  static const String appID = "6745581827";

  static const String baseDomain = "superb-notable-brilliance.space";
  static const String verificationParam = "oxLTQDE0";
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final now = DateTime.now();
  final dateOff = DateTime(2025, 6, 2, 20, 00);

  final initialRoute = now.isBefore(dateOff) ? '/white' : '/verify';
  runApp(RootApp(
    initialRoute: initialRoute,
    whiteScreen: MainApp(),
  ));
}
