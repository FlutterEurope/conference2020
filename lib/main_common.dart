import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:conferenceapp/utils/bloc_delegate.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'analytics.dart';
import 'app.dart';

void mainCommon() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned<Future<void>>(() async {
    analytics = FirebaseAnalytics();

    runApp(MyApp(title: "Flutter Europe"));
  }, onError: Crashlytics.instance.recordError);
}
