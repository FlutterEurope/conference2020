import 'package:conferenceapp/model/talk.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AgendaEvent {}

class InitAgenda extends AgendaEvent {}

class AgendaUpdated extends AgendaEvent {
  AgendaUpdated(this.talks);
  final List<Talk> talks;
}

class FetchAgenda extends AgendaEvent {}
