import 'package:conferenceapp/model/talk.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AgendaState {}

class InitialAgendaState extends AgendaState {}

class LoadingAgendaState extends AgendaState {}

class PopulatedAgendaState extends AgendaState {
  PopulatedAgendaState(List<Talk> talks) {
    final dates = talks
        .map((t) => DateTime(t.dateTime.year, t.dateTime.month, t.dateTime.day))
        .toSet() //this removes duplicates
        .toList()
          ..sort((n, m) => n.compareTo(m));
    _talks.addAll({
      for (var i = 0; i < dates.length; i++)
        i: talks
            .where((t) => t.dateTime.isAfter(dates[i]) && t.dateTime.isBefore(dates[i].add(Duration(days: 1))))
            .toList()
    });
  }
  final _talks = Map<int, List<Talk>>();
  Map<int, List<Talk>> get talks => _talks;
}

class ErrorAgendaState extends AgendaState {}
