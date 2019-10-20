import 'package:bloc/bloc.dart';
import 'package:conferenceapp/utils/bloc_delegate.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void mainCommon() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(MyApp(title: "Flutter Europe"));
}
