import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:conferenceapp/agenda/repository/talks_repository.dart';
import './bloc.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  AgendaBloc(this.talkRepository);

  final TalkRepository talkRepository;

  @override
  AgendaState get initialState => InitialAgendaState();

  @override
  Stream<AgendaState> mapEventToState(
    AgendaEvent event,
  ) async* {
    if (event is InitAgenda) {
      yield* mapInitToState(event);
    }
  }

  Stream<AgendaState> mapInitToState(InitAgenda event) async* {
    yield LoadingAgendaState();
    await Future.delayed(Duration(seconds: 1));
    yield PopulatedAgendaState(talkRepository.talks);
  }
}
