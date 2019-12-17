import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:conferenceapp/config.dart';
import 'package:conferenceapp/utils/bloc_delegate.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'analytics.dart';
import 'app.dart';

void mainCommon({@required AppConfig config}) {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    analytics = FirebaseAnalytics();
    config = config;
    final sharedPrefs = await SharedPreferences.getInstance();

    runApp(
      MyApp(
        title: "Flutter Europe",
        sharedPreferences: sharedPrefs,
      ),
    );
  }, onError: (error, stack) => Crashlytics.instance.recordError(error, stack));
}
