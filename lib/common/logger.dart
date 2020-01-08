import 'package:flutter/foundation.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';

class Logger {
  static bool printToConsole = false;

  static info(String message) {
    if (printToConsole) debugPrint(message);
    FlutterBugfender.log(message);
  }

  static error(String message) {
    if (printToConsole) debugPrint(message);
    FlutterBugfender.error(message);
  }

  static errorException(Exception e, [StackTrace s]) {
    if (printToConsole) print(e);
    if (printToConsole && s != null) print(s);
    FlutterBugfender.error('Exception: $e.\nStacktrace: $s');
  }

  static warn(String message) {
    if (printToConsole) debugPrint(message);
    FlutterBugfender.warn(message);
  }
}
