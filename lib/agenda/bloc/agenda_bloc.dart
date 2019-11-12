import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:conferenceapp/agenda/repository/talks_repository.dart';

import './bloc.dart';

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  AgendaBloc(this.talksRepository);

  final TalkRepository talksRepository;
  StreamSubscription talksSubscription;

  @override
  AgendaState get initialState => InitialAgendaState();

  @override
  Stream<AgendaState> mapEventToState(
    AgendaEvent event,
  ) async* {
    if (event is InitAgenda) {
      yield* mapInitToState(event);
    }
    if (event is AgendaUpdated) {
      yield* mapUpdateToState(event);
    }
  }

  Stream<AgendaState> mapInitToState(InitAgenda event) async* {
    talksSubscription?.cancel();
    talksSubscription = talksRepository.talks().listen(
          (talks) => add(AgendaUpdated(talks)),
        );
    yield LoadingAgendaState();
  }

  Stream<AgendaState> mapUpdateToState(AgendaUpdated event) async* {
    yield PopulatedAgendaState(event.talks);
  }

  @override
  Future<void> close() {
    talksSubscription?.cancel();
    return super.close();
  }
}
