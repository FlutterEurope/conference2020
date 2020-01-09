import 'package:flutter/foundation.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';
import 'package:stack_trace/stack_trace.dart';

class Logger {
  static bool printToConsole = false;

  static info(String message) {
    final className = Trace.current().frames[1].member.split(".")[0];
    final methodName = Trace.current().frames[1].member.split(".")[1];
    if (printToConsole) debugPrint(message);
    FlutterBugfender.l(message,
        tag: 'Info', methodName: methodName, className: className);
  }

  static error(String message) {
    final className = Trace.current().frames[1].member.split(".")[0];
    final methodName = Trace.current().frames[1].member.split(".")[1];
    if (printToConsole) debugPrint(message);
    FlutterBugfender.l(message,
        tag: 'Error', methodName: methodName, className: className);
    FlutterBugfender.forceSendOnce();
  }

  static errorException(Exception e, [StackTrace s]) {
    if (printToConsole) print(e);
    if (printToConsole && s != null) print(s);

    FlutterBugfender.error('Exception: $e.\nStacktrace: $s');
    FlutterBugfender.forceSendOnce();
  }

  static warn(String message) {
    final className = Trace.current().frames[1].member.split(".")[0];
    final methodName = Trace.current().frames[1].member.split(".")[1];
    if (printToConsole) debugPrint(message);
    FlutterBugfender.l(message,
        tag: 'Warn', methodName: methodName, className: className);
    FlutterBugfender.forceSendOnce();
  }
}
