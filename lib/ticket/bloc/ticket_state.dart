import 'package:meta/meta.dart';

@immutable
abstract class TicketState {}

class InitialTicketState extends TicketState {}

class NoTicketState extends TicketState {}

class TicketErrorState extends TicketState {}

class TicketValidState extends TicketState {}

class NewTicketAddedState extends TicketValidState {}
