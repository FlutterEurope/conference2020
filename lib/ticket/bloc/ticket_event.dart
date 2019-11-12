import 'package:meta/meta.dart';

@immutable
abstract class TicketEvent {}

abstract class AddTicket extends TicketEvent {}

class AddTicketFromCamera extends AddTicket {}

class AddTicketManually extends AddTicket {}
