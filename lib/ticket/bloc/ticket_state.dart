import 'package:meta/meta.dart';

@immutable
abstract class TicketState {}

class NoTicketState extends TicketState {}

class TicketDataFilledState extends TicketValidState {}

class TicketLoadingState extends TicketState {}

class TicketValidState extends TicketState {}

class TicketErrorState extends TicketState {}