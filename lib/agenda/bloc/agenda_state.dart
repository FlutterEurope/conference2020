import 'package:conferenceapp/model/room.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AgendaState {}

class InitialAgendaState extends AgendaState {}

class LoadingAgendaState extends AgendaState {}

class PopulatedAgendaState extends AgendaState {
  PopulatedAgendaState(List<Talk> talks) {
    final dates = talks
        .map((t) =>
            DateTime(t.startTime.year, t.startTime.month, t.startTime.day))
        .toSet() //this removes duplicates
        .toList()
          ..sort((n, m) => n.compareTo(m));
          
    _rooms.addAll(talks.map<Room>((t) => t.room).toSet().toList());

    _talks.addAll({
      for (var i = 0; i < dates.length; i++)
        i: talks
            .where((t) =>
                (t.startTime.isAfter(dates[i]) ||
                    t.startTime ==
                        dates[
                            i]) && //we need talks from the day 't' but also ones starting at 0:00
                t.startTime.isBefore(dates[i]
                    .add(Duration(days: 1)))) // up to 0:00 of the next day
            .toList()
              ..sort((n, m) => n.compareTo(m))
    });
  }
  final _talks = Map<int, List<Talk>>();
  final _rooms = List<Room>();
  Map<int, List<Talk>> get talks => _talks;
  List<Room> get rooms => _rooms;
}

class ErrorAgendaState extends AgendaState {}
