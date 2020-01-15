import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/config.dart';
import 'package:conferenceapp/utils/bloc_delegate.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'app.dart';
import 'utils/analytics.dart';

void mainCommon({@required AppConfig config}) {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = (error) {
    logger.error(error.exceptionAsString());
    Crashlytics.instance.recordFlutterError(error);
  };

  runZoned<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    analytics = FirebaseAnalytics();
    appConfig = config;
    final sharedPrefs = await SharedPreferences.getInstance();
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    FlutterBugfender.init(appConfig.bugfenderKey);

    runApp(
      MyApp(
        title: "Flutter Europe",
        sharedPreferences: sharedPrefs,
        firebaseMessaging: firebaseMessaging,
      ),
    );
  }, onError: (error, stack) {
    logger.errorException(error, stack);
    return Crashlytics.instance.recordError(error, stack);
  });
}
