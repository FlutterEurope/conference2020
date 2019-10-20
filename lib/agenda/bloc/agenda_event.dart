import 'package:meta/meta.dart';

@immutable
abstract class AgendaEvent {}

class SwitchDay extends AgendaEvent {
  SwitchDay(this.day);
  final int day;
}

class InitAgenda extends AgendaEvent {}
