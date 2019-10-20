import 'package:conferenceapp/model/talk.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AgendaState {}

class InitialAgendaState extends AgendaState {}

class LoadingAgendaState extends AgendaState {}

class PopulatedAgendaState extends AgendaState {
  PopulatedAgendaState(this.selectedDay, this.talks);
  final DateTime selectedDay;
  final List<Talk> talks;
}

class ErrorAgendaState extends AgendaState {}
